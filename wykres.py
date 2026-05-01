import matplotlib.pyplot as plt
from datetime import datetime

# Dane wejściowe
dane = [
    ("2022-07", 176), ("2022-08", 49), ("2022-09", 31), ("2022-10", 172), ("2022-11", 73),
    ("2022-12", 46), ("2023-01", 119), ("2023-02", 46), ("2023-03", 84), ("2023-04", 65),
    ("2023-05", 33), ("2023-07", 121), ("2023-08", 128), ("2023-09", 33), ("2023-10", 170),
    ("2023-11", 38), ("2023-12", 80), ("2024-01", 45), ("2024-02", 48), ("2024-03", 82),
    ("2024-04", 114), ("2024-05", 66), ("2024-07", 148), ("2024-08", 45), ("2024-09", 30),
    ("2024-10", 120), ("2024-11", 93), ("2024-12", 42), ("2025-01", 126)
]

# Konwersja danych na osobne listy
rok_miesiac = [datetime.strptime(row[0], "%Y-%m") for row in dane]
liczba_klientow = [row[1] for row in dane]

# Tworzenie wykresu
plt.figure(figsize=(12, 6))
plt.plot(rok_miesiac, liczba_klientow, marker='o', label='Liczba klientów')

plt.title("Liczba klientów w poszczególnych miesiącach", fontsize=14)
plt.xlabel("Rok-Miesiąc", fontsize=12)
plt.ylabel("Liczba klientów", fontsize=12)
plt.grid(True, linestyle='--', alpha=0.6)
plt.xticks(rotation=45)
plt.legend()

plt.tight_layout()
plt.show()