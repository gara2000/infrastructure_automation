FROM python:3.9-slim

COPY src/app/requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install -r requirements.txt

COPY src/app/app.py ./app.py

ENTRYPOINT [ "python" ]
CMD [ "app.py" ]