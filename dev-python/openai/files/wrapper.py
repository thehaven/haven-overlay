#!/usr/bin/env python3
"""
OpenAI wrapper script for LLM observability
This script is installed when the debug USE flag is enabled
"""

import os
import sys

def install_openai_wrapper():
    """Install the OpenAI wrapper when debug mode is enabled"""
    if os.getenv("HERMES_DEBUG_LLM") == "1":
        try:
            import hermes_observability
            import openai
            
            # Monkey patch OpenAI client when debug enabled
            original_client = openai.OpenAI
            def observable_openai(*args, **kwargs):
                return hermes_observability.ObservableLLMClient(original_client(*args, **kwargs))
            
            openai.OpenAI = observable_openai
            print("✅ OpenAI observability wrapper installed")
            return True
            
        except ImportError as e:
            print(f"❌ Failed to install OpenAI wrapper: {e}")
            return False
    else:
        print("ℹ️ Debug mode not enabled - wrapper not installed")
        return True

if __name__ == "__main__":
    success = install_openai_wrapper()
    sys.exit(0 if success else 1)