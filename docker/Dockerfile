FROM python:3.9-slim



# hello test
COPY app/requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install -r requirements.txt

COPY app/app.py ./app.py

ENTRYPOINT [ "python" ]
CMD [ "app.py" ]