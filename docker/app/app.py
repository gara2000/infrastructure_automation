# from flask import Flask

# app = Flask(__name__)

# @app.route('/')
# def hello():
#     return 'Hellooo!'

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=8080, debug=True)

from flask import Flask, request, jsonify

import pandas as pd
import joblib
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import GradientBoostingClassifier

app = Flask(__name__)

def scale(payload):
    """Scales Payload"""

    app.logger.info("Scaling Payload: %s", payload)
    scaler = StandardScaler().fit(payload)
    scaled_adhoc_predict = scaler.transform(payload)
    return scaled_adhoc_predict


@app.route("/")
def home():
    html = (
        "<h3>Welcome to Sklearn Bostong Housing Price Prediction</h3>"
    )
    return html.format(format)

@app.route("/predict", methods=["POST"])
def predict():
    """Performs a sklearn prediction

    input looks like:
            {
    "CHAS":{
      "0":0
    },
    "RM":{
      "0":6.575
    },
    "TAX":{
      "0":296.0
    },
    "PTRATIO":{
       "0":15.3
    },
    "B":{
       "0":396.9
    },
    "LSTAT":{
       "0":4.98
    }

    result looks like:
    { "prediction": [ 30.084999999999987 ] }

    """

    try:
        clf = joblib.load("boston_housing_prediction.joblib")
    except Exception as e:
        app.logger.info("Failed to load model: %s", e)
        return "Model not loaded"

    json_payload = request.json
    app.logger.info("JSON payload: %s", json_payload)
    inference_payload = pd.DataFrame(json_payload)
    app.logger.info("Inference payload DataFrame: %s",  inference_payload)
    scaled_payload = scale(inference_payload)
    prediction = list(clf.predict(scaled_payload))
    return jsonify({"prediction": prediction})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
