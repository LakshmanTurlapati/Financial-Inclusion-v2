import pickle
import pandas as pd
from flask import Flask, jsonify, request
import os
import joblib

app = Flask(__name__)

# File paths
csv_path = "./X_test_with_SSN.csv"  
model_path = "./stacked_model.pkl"  

# Load the CSV data
try:
    csv_data = pd.read_csv(csv_path)  # Requires s3fs if using S3 paths
    print(csv_data.head())  # Display the first few rows to confirm data load
    print(csv_data.columns)  # Check for column names
except FileNotFoundError:
    raise Exception(f"CSV file not found at path: {csv_path}")
except Exception as e:
    raise Exception(f"Error reading CSV: {e}")

# Load pre-trained model
try:
    with open(model_path, "rb") as file:
        model = joblib.load(file)
except FileNotFoundError:
    raise Exception(f"Model file not found at path: {model_path}")

# Path to the output CSV for logging predictions
output_csv_path = os.path.join(os.getcwd(), "prediction_logs.csv")

@app.route("/", methods=["GET"])
def home():
    """Default route for testing."""
    return jsonify({
        "message": "Welcome to the Prediction API!",
        "instructions": "Send a POST request to /generate-prediction with an SSN to get Pre_Cursor_Credit_Score."
    }), 200

@app.route("/generate-prediction", methods=["POST"])
def generate_prediction():
    """Generate Pre_Cursor_Credit_Score based on SSN."""
    try:
        # Parse JSON input
        input_data = request.get_json()
        ssn = input_data.get("ssn")

        # Validate input
        if not ssn:
            return jsonify({"error": "SSN is required"}), 400

        # Verify SSN in the CSV
        user_data = csv_data[csv_data["SSN"].astype(str).str.strip() == ssn.strip()]
        if user_data.empty:
            return jsonify({"error": "SSN not found in the CSV"}), 404

        # Extract user details for prediction
        user_row = user_data.iloc[0]
        features = [
            user_row["Age"],
            user_row["Annual_Income"],
            user_row["Monthly_Income"],
            user_row["Amount_Invested_Monthly"],
            user_row["Card_Transactions_Per_Month"],
            user_row["Average_Transaction_Amount"],
            user_row["Rent_Expenditure"],
            user_row["Utilities_Expenditure"],
            user_row["Education_Expenditure"],
            user_row["Healthcare_Expenditure"],
            user_row["Luxury_Expenditure"],
            user_row["Travel_Expenditure"],
            user_row["Savings_to_Income_Ratio"],
            user_row["Missed_Payment_Utilities"],
            user_row["Missed_Payment_Insurance"],
            user_row["Employment_Stability"],
            user_row["Debt_to_Income_Ratio"],
            user_row["Savings_Account_Balance"],
            user_row["Dependents"],
            user_row["Aspirational_Spending_Ratio"],
            user_row["Emergency_Fund_Ratio"],
            user_row["Overdraft_Fees"],
        ]

        # Generate Pre_Cursor_Credit_Score using the model
        prediction = model.predict([features])[0]

        # Log the prediction to a CSV file
        log_data = {
            "SSN": ssn,
            "Age": user_row["Age"],
            "Annual_Income": user_row["Annual_Income"],
            "Pre_Cursor_Credit_Score": prediction
        }

        if not os.path.exists(output_csv_path):
            pd.DataFrame([log_data]).to_csv(output_csv_path, index=False)
        else:
            pd.DataFrame([log_data]).to_csv(output_csv_path, mode="a", header=False, index=False)

        # Return the result
        return jsonify({
            "ssn": ssn,
            "pre_cursor_credit_score": prediction
        }), 200

    except KeyError as e:
        return jsonify({"error": f"Missing required column in CSV: {str(e)}"}), 500
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)