#!/usr/bin/env python3
"""
LiteLLM wrapper script for LLM observability
This script is installed when the debug USE flag is enabled
"""

import os
import sys

def install_litellm_wrapper():
    """Install the LiteLLM wrapper when debug mode is enabled"""
    if os.getenv("HERMES_DEBUG_LLM") == "1":
        try:
            import hermes_observability
            import litellm
            
            # Monkey patch LiteLLM completion function when debug enabled
            original_completion = litellm.completion
            def observable_completion(*args, **kwargs):
                # Create observable wrapper for the completion
                mock_client = type('MockClient', (), {'completion': lambda **k: original_completion(*args, **kwargs)})()
                return hermes_observability.ObservableLLMClient(mock_client).completion(**kwargs)
            
            litellm.completion = observable_completion
            print("✅ LiteLLM observability wrapper installed")
            return True
            
        except ImportError as e:
            print(f"❌ Failed to install LiteLLM wrapper: {e}")
            return False
    else:
        print("ℹ️ Debug mode not enabled - wrapper not installed")
        return True

if __name__ == "__main__":
    success = install_litellm_wrapper()
    sys.exit(0 if success else 1)