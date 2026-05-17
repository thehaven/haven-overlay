#!/usr/bin/env python3
"""
Anthropic wrapper script for LLM observability
This script is installed when the debug USE flag is enabled
"""

import os
import sys

def install_anthropic_wrapper():
    """Install the Anthropic wrapper when debug mode is enabled"""
    if os.getenv("HERMES_DEBUG_LLM") == "1":
        try:
            import hermes_observability
            import anthropic
            
            # Monkey patch Anthropic client when debug enabled
            original_client = anthropic.Anthropic
            def observable_anthropic(*args, **kwargs):
                return hermes_observability.ObservableLLMClient(original_client(*args, **kwargs))
            
            anthropic.Anthropic = observable_anthropic
            print("✅ Anthropic observability wrapper installed")
            return True
            
        except ImportError as e:
            print(f"❌ Failed to install Anthropic wrapper: {e}")
            return False
    else:
        print("ℹ️ Debug mode not enabled - wrapper not installed")
        return True

if __name__ == "__main__":
    success = install_anthropic_wrapper()
    sys.exit(0 if success else 1)