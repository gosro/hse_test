import requests

URL = "http://<your_service_url>/predict"

def send_request(text):
    response = requests.post(URL, json={"text": text})
    if response.status_code == 200:
        return response.json()['result']
    else:
        return f"Ошибка: {response.text}"

def main():
    print("Введите 'выход' для завершения.")
    while True:
        text = input("Введите текст: ")
        if text.lower() == 'выход':
            break
        result = send_request(text)
        print("Ответ модели:", result)

if __name__ == "__main__":
    main()
