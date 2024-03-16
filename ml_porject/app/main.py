from flask import Flask, request, jsonify
from transformers import GPT2LMHeadModel, GPT2Tokenizer
from clearml import Task
import os

CLEARML_API_HOST = os.getenv("CLEARML_API_HOST", "http://localhost:8008")
CLEARML_WEB_HOST = os.getenv("CLEARML_WEB_HOST", "http://localhost:80")
CLEARML_API_ACCESS_KEY = os.getenv("CLEARML_API_ACCESS_KEY", "default_access_key")
CLEARML_API_SECRET_KEY = os.getenv("CLEARML_API_SECRET_KEY", "default_secret_key")

Task.set_credentials(
    api_host=CLEARML_API_HOST,
    web_host=CLEARML_WEB_HOST,
    files_host=CLEARML_API_HOST,
    key=CLEARML_API_ACCESS_KEY,
    secret=CLEARML_API_SECRET_KEY,
)

task = Task.init(project_name="MLOps with ClearML", task_name="GPT-2 Inference Service", task_type=Task.TaskTypes.inference)

app = Flask(__name__)

model = GPT2LMHeadModel.from_pretrained("distilgpt2")
tokenizer = GPT2Tokenizer.from_pretrained("distilgpt2")
model.eval()

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    input_text = data['text']
    inputs = tokenizer.encode(input_text, return_tensors='pt')
    outputs = model.generate(inputs, max_length=100)
    result = tokenizer.decode(outputs[0], skip_special_tokens=True)
    
    task.get_logger().report_text(f"input: {input_text}\noutput: {result}")
    
    return jsonify({'result': result})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
