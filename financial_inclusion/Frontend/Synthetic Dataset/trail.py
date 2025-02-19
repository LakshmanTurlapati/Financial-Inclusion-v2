import numpy as np
import pandas as pd
import uuid

def generate_synthetic_data(num_samples=5000, random_seed=42):
    """
    Generates a synthetic dataset for individuals who are eligible for a credit card
    but do not have one, focusing on financial, behavioral, and demographic indicators.
    
    Args:
        num_samples (int): Number of data rows to generate.
        random_seed (int): Random seed for reproducibility.
    
    Returns:
        pd.DataFrame: A DataFrame with all features and the pre-cursor credit score.
    """
    np.random.seed(random_seed)
    
    # -----------------------------
    # 1. Person_ID
    # -----------------------------
    person_ids = [str(uuid.uuid4()) for _ in range(num_samples)]
    
    # -----------------------------
    # 2. Age (18–65)
    #    Slightly higher density in 25–45
    # -----------------------------
    # One approach: generate from a normal distribution around 35
    # and clip between 18 and 65.
    ages = np.clip(np.random.normal(loc=35, scale=10, size=num_samples), 18, 65).round().astype(int)
    
    # -----------------------------
    # 3. Annual_Income ($10k–$150k)
    #    Normal dist around $50k, clipped
    # -----------------------------
    annual_income = np.random.normal(loc=50000, scale=20000, size=num_samples)
    annual_income = np.clip(annual_income, 10000, 150000).round(2)
    
    # -----------------------------
    # 4. Rent_Amount ($300–$3000/month)
    #    Normal distribution around $1200
    # -----------------------------
    rent_amount = np.random.normal(loc=1200, scale=400, size=num_samples)
    rent_amount = np.clip(rent_amount, 300, 3000).round(2)
    
    # -----------------------------
    # 5. Utilities_Amount ($50–$500/month)
    #    Correlated with Rent_Amount:
    #    Let's set utilities ~ 0.25 * rent + normal(0, 50), then clip
    # -----------------------------
    utilities_amount = 0.25 * rent_amount + np.random.normal(loc=0, scale=50, size=num_samples)
    utilities_amount = np.clip(utilities_amount, 50, 500).round(2)
    
    # -----------------------------
    # 6. Education_Expenditure ($0–$30,000/year)
    #    70% near 0, 30% higher
    # -----------------------------
    # A simple approach:
    # - With 70% probability: near 0 (random 0 to 500)
    # - With 30% probability: random from 500 to 30000
    education_expenditure = []
    for _ in range(num_samples):
        if np.random.rand() < 0.7:
            # near 0
            education_expenditure.append(np.random.uniform(0, 500))
        else:
            # up to 30000
            education_expenditure.append(np.random.uniform(500, 30000))
    education_expenditure = np.array(education_expenditure).round(2)
    
    # -----------------------------
    # 7. Healthcare_Expenditure ($0–$20,000/year)
    #    Random uniform, but slightly higher for older individuals
    # -----------------------------
    # We'll scale by (age / 65.0) to add a mild correlation
    base_health = np.random.uniform(0, 20000, size=num_samples)
    healthcare_expenditure = (base_health * (ages / 65.0)).clip(0, 20000).round(2)
    
    # -----------------------------
    # 8. Luxury_Spending ($0–$50,000/year)
    #    Correlated with Annual_Income
    # -----------------------------
    # A fraction of income, up to 50k
    # We'll let fraction = uniform(0, 0.5), so max 50% of income
    # Then cap at 50k
    fraction_luxury = np.random.uniform(0, 0.5, size=num_samples)
    luxury_spending = (annual_income * fraction_luxury).clip(0, 50000).round(2)
    
    # -----------------------------
    # 9. Savings_to_Income_Ratio (0.05–1.0)
    #    Higher for middle-aged, lower for younger
    # -----------------------------
    # We'll do a random draw, then slightly adjust based on age
    # Baseline: uniform(0.05, 1.0)
    # If age < 25: push ratio a bit lower; if age > 45: push ratio a bit higher
    base_savings_ratio = np.random.uniform(0.05, 1.0, size=num_samples)
    savings_to_income_ratio = []
    for i in range(num_samples):
        if ages[i] < 25:
            ratio = base_savings_ratio[i] * np.random.uniform(0.5, 0.8)  # lower
        elif ages[i] > 45:
            ratio = base_savings_ratio[i] * np.random.uniform(1.0, 1.2)  # higher
        else:
            ratio = base_savings_ratio[i]
        # clip to max 1.0
        ratio = min(ratio, 1.0)
        savings_to_income_ratio.append(ratio)
    savings_to_income_ratio = np.array(savings_to_income_ratio).round(3)
    
    # -----------------------------
    # 10. Travel_Expenditure ($0–$20,000/year)
    #     Correlated with income
    # -----------------------------
    # We'll do fraction of annual income up to 20k
    fraction_travel = np.random.uniform(0, 0.3, size=num_samples)
    travel_expenditure = (annual_income * fraction_travel).clip(0, 20000).round(2)
    
    # -----------------------------
    # 11 & 12. Missed_Payment_Rent (0–12), Missed_Payment_Utilities (0–12)
    #          Correlated with each other
    # -----------------------------
    # We'll pick missed rent from 0 to 12.
    # Then missed utilities ~ missed rent plus noise
    missed_payment_rent = np.random.randint(0, 13, size=num_samples)
    # Let's assume a correlation factor: missed utilities = missed rent +/- up to 2
    missed_payment_utilities = missed_payment_rent + np.random.randint(-2, 3, size=num_samples)
    missed_payment_utilities = np.clip(missed_payment_utilities, 0, 12)
    
    # -----------------------------
    # 13. Employment_Stability (0–20 years)
    #     Higher for older individuals
    # -----------------------------
    # We'll do min(age - 18, 20) as an upper bound
    employment_stability = []
    for i in range(num_samples):
        max_possible = min(ages[i] - 18, 20)
        if max_possible < 0:  # edge case, should not happen if age>=18
            max_possible = 0
        employment_stability.append(np.random.randint(0, max_possible + 1))
    employment_stability = np.array(employment_stability)
    
    # -----------------------------
    # 14. Debt_to_Income_Ratio (0.0–2.0)
    #     Most below 0.5
    # -----------------------------
    # We can generate from a beta distribution (alpha=2, beta=5) -> skewed to lower side
    # Then scale up to 2.0
    debt_to_income_base = np.random.beta(a=2, b=5, size=num_samples)
    debt_to_income_ratio = (debt_to_income_base * 2.0).round(3)
    
    # -----------------------------
    # 15. Tax_Compliance (Binary)
    #     90% = 1 (Compliant), 10% = 0
    # -----------------------------
    tax_compliance = (np.random.rand(num_samples) < 0.9).astype(int)
    
    # -----------------------------
    # 16. Dependents (0–5)
    #     Higher values for older individuals, but randomly distributed
    # -----------------------------
    # We'll pick from 0 to 5, but weight older individuals to have more dependents
    # A simple approach: (age / 65) ~ chance of having more dependents
    dependents = []
    for i in range(num_samples):
        # base random 0..5
        # prob of a higher number if older
        age_factor = ages[i] / 65.0
        # random integer 0..5, weight older
        # e.g. pick from a distribution around (5 * age_factor)
        mean_dep = 5 * age_factor
        # We'll pick from normal(mean_dep, 1.5) and clip
        dep = int(np.clip(np.random.normal(loc=mean_dep, scale=1.5), 0, 5))
        dependents.append(dep)
    dependents = np.array(dependents)
    
    # -----------------------------
    # 17. Aspirational_Spending_Ratio (0.0–0.5)
    #     (Luxury + Travel) / Income
    # -----------------------------
    aspirational_spending_ratio = (luxury_spending + travel_expenditure) / np.maximum(annual_income, 1)
    aspirational_spending_ratio = np.clip(aspirational_spending_ratio, 0, 0.5).round(3)
    
    # -----------------------------
    # 18. Emergency_Fund_Ratio (0.1–10.0)
    #     = (Savings) / (Rent + Utilities + Healthcare [monthly])
    # -----------------------------
    # Approximate monthly savings = annual_income * savings_to_income_ratio / 12
    # Healthcare monthly = healthcare_expenditure / 12
    monthly_savings = (annual_income * savings_to_income_ratio) / 12.0
    monthly_healthcare = healthcare_expenditure / 12.0
    # Avoid divide by zero
    denom = rent_amount + utilities_amount + monthly_healthcare
    # If denom = 0 (unlikely but possible), set to 1 to avoid error
    denom = np.where(denom <= 0, 1, denom)
    
    emergency_fund_ratio = monthly_savings / denom
    # Clip between 0.1 and 10
    emergency_fund_ratio = np.clip(emergency_fund_ratio, 0.1, 10).round(3)
    
    # -----------------------------
    # Add a simple approach for outliers
    # e.g., 1% chance an individual has extremely high Luxury_Spending
    # -----------------------------
    outlier_indices = np.random.choice([False, True], size=num_samples, p=[0.99, 0.01])
    luxury_spending[outlier_indices] = luxury_spending[outlier_indices] * np.random.uniform(1.5, 3.0)
    luxury_spending = np.clip(luxury_spending, 0, 50000).round(2)
    
    # Recompute aspirational_spending_ratio for outliers
    aspirational_spending_ratio = (luxury_spending + travel_expenditure) / np.maximum(annual_income, 1)
    aspirational_spending_ratio = np.clip(aspirational_spending_ratio, 0, 0.5).round(3)
    
    # -----------------------------
    # 19. Pre-cursor Credit Score
    #     Weighted sum:
    #         35%: Payment history -> (1 - missed_payment_rate)
    #              missed_payment_rate = (rent + utility) / (24)
    #         25%: (1 - debt_to_income_ratio_scaled) -> dti / 2.0
    #         15%: savings_to_income_ratio
    #         10%: emergency_fund_ratio (scaled to 0..1 by /10)
    #         10%: employment_stability (scaled to 0..1 by /20)
    #         5%: tax_compliance
    #
    #     Then scale final [0..1] -> [300..850]
    # -----------------------------
    missed_payment_rate = (missed_payment_rent + missed_payment_utilities) / 24.0
    dti_scaled = debt_to_income_ratio / 2.0
    emergency_fund_scaled = emergency_fund_ratio / 10.0
    employment_stability_scaled = employment_stability / 20.0
    
    # Weighted sum
    score_0_1 = (0.35 * (1 - missed_payment_rate) +
                 0.25 * (1 - dti_scaled) +
                 0.15 * savings_to_income_ratio +
                 0.10 * emergency_fund_scaled +
                 0.10 * employment_stability_scaled +
                 0.05 * tax_compliance)
    
    # Scale to 300–850
    pre_cursor_credit_score = 300 + score_0_1 * (850 - 300)  # 550 * score_0_1 + 300
    pre_cursor_credit_score = pre_cursor_credit_score.round(2)
    
    # -----------------------------
    # Create the DataFrame
    # -----------------------------
    data = pd.DataFrame({
        "Person_ID": person_ids,
        "Age": ages,
        "Annual_Income": annual_income,
        "Rent_Amount": rent_amount,
        "Utilities_Amount": utilities_amount,
        "Education_Expenditure": education_expenditure,
        "Healthcare_Expenditure": healthcare_expenditure,
        "Luxury_Spending": luxury_spending,
        "Savings_to_Income_Ratio": savings_to_income_ratio,
        "Travel_Expenditure": travel_expenditure,
        "Missed_Payment_Rent": missed_payment_rent,
        "Missed_Payment_Utilities": missed_payment_utilities,
        "Employment_Stability": employment_stability,
        "Debt_to_Income_Ratio": debt_to_income_ratio,
        "Tax_Compliance": tax_compliance,
        "Dependents": dependents,
        "Aspirational_Spending_Ratio": aspirational_spending_ratio,
        "Emergency_Fund_Ratio": emergency_fund_ratio,
        "Pre_Cursor_Credit_Score": pre_cursor_credit_score
    })
    
    return data


if __name__ == "__main__":
    # Generate the dataset
    df = generate_synthetic_data(num_samples=5000, random_seed=42)
    
    # Show a preview
    print(df.head(10))
    
    # Optionally, save to CSV
    df.to_csv("synthetic_credit_data.csv", index=False)
    print("\nSynthetic dataset saved to 'synthetic_credit_data.csv'.")