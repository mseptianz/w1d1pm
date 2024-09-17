
import unittest
from test.py import calories_burned
from test.py import total_calories_burned


class TestAddNumbers(unittest.TestCase):
  def test_calories_burned(self):
    result = calories_burned(60,'bersepeda')
    self.assertEqual(result, 480)
  def test_total_calories_burned(self):
    result = total_calories_burned(30,'berlari','berenang')
    self.assertEqual(result, 660)

if __name__ == "__main__":
  unittest.main()
  