def calories_burned(duration, exercise):
  if exercise == "berlari":
    return duration * 10
  elif exercise == "bersepeda":
    return duration * 8 
  elif exercise == "berenang":
    return duration * 12
  else:
    return "exercise tidak tersedia"
calories_burned(60,'bersepeda')

def total_calories_burned(each_session_duration, *exercises):
    # Dictionary to map exercises to their calorie burn rates
    calorie_rates = {
        "berlari": 10,
        "bersepeda": 8,
        "berenang": 12
    }
    
    total_calories = 0
    
    for exercise in exercises:
        if exercise in calorie_rates:
            total_calories += each_session_duration * calorie_rates[exercise]
        else:
            return "Exercise tidak tersedia"
    
    return total_calories
calories = total_calories_burned(30, "berlari", "berenang")
print(calories)  # Output: 660 (30 * 10 + 30 * 12)

import unittest


class TestAddNumbers(unittest.TestCase):
  def test_calories_burned(self):
    result = calories_burned(60,'bersepeda')
    self.assertEqual(result, 480)
  def test_total_calories_burned(self):
    result = total_calories_burned(10,'berlari','berenang')
    self.assertEqual(result, 660)

if __name__ == "__main__":
  unittest.main()
  