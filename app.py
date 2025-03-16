import os
import subprocess
import threading
import time
import sys

# Set environment variables to fix permission issues
os.environ["MPLCONFIGDIR"] = "/tmp/matplotlib"
os.environ["RASA_USER_HOME"] = "/tmp/rasa"
os.environ["SQLALCHEMY_SILENCE_UBER_WARNING"] = "1"

# Ensure models directory exists in writable location
models_dir = "/tmp/models"
if not os.path.exists(models_dir):
    os.makedirs(models_dir, exist_ok=True)
    print(f"Created models directory at {models_dir}")

# Function to run Rasa action server
def run_action_server():
    print("Starting Rasa Action Server...")
    try:
        # Action server usually runs on port 5055
        action_process = subprocess.Popen(
            ["rasa", "run", "actions", "--port", "5055"],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        )
        
        # Stream output for debugging
        for line in action_process.stdout:
            sys.stdout.write(f"[Action Server] {line.decode()}")
            sys.stdout.flush()
            
    except Exception as e:
        print(f"Error starting Action Server: {e}", file=sys.stderr)

# Start the action server in a separate thread
action_thread = threading.Thread(target=run_action_server, daemon=True)
action_thread.start()

# Wait a bit to let the action server initialize
print("Waiting for Action Server to initialize...")
time.sleep(10)

# Start the main Rasa server
print("Starting Rasa Main Server...")
try:
    # The endpoint config needs to point to the action server
    cmd = [
        "rasa", 
        "run", 
        "--enable-api", 
        "--cors", "*", 
        "--port", "7860",
        "--endpoints", "endpoints.yml",  # Make sure endpoints.yml contains action_endpoint
    ]
    
    # If a model file is found, use it
    model_files = [f for f in os.listdir(".") if f.endswith(".tar.gz")]
    if model_files:
        print(f"Found model file: {model_files[0]}")
        cmd.extend(["--model", model_files[0]])
    
    print(f"Running command: {' '.join(cmd)}")
    rasa_process = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT
    )
    
    # Stream output for debugging
    for line in rasa_process.stdout:
        sys.stdout.write(f"[Rasa Server] {line.decode()}")
        sys.stdout.flush()
        
except Exception as e:
    print(f"Error starting Rasa server: {e}", file=sys.stderr)
