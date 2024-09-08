# test_python_scripts.py
# run from top level of repo
import unittest
from ..python_scripts import first_script, second_script

class TestScripts(unittest.TestCase):

    def test_first_script(self):
        returned_list = first_script.count_to_five()
        length = len(returned_list)
        last_value = returned_list[-1]
        self.assertEqual(length, 5)
        self.assertEqual(last_value, 5)

    def test_second_script(self):
        returned_value = second_script.say_hello()
        self.assertEqual(returned_value, 'AHOY!')

if __name__ == '__main__':
    unittest.main()
