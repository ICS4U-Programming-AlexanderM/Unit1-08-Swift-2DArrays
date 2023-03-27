import Foundation
//  Created by Alexander Matheson
//  Created on 2023-Mar-25
//  Version 1.0
//  Copyright (c) 2023 Alexander Matheson. All rights reserved.
//
//  This program generates marks for each student and assignment.

// Generate random numbers with a set mean and standard deviation.
// Found here: https://stackoverflow.com/questions/74512975/how-to-generate-large-number-of-gaussian-random-variables-in-swift.
// Edited slightly by me to replace the GameplayKit library that does not work with Ubuntu.
// Most of these edits were trial and error until something works.
// The random distribution looks right to me, but I haven't done the math to confirm.
func randomNormalValue(mean: Double, standardDeviation: Double) -> Int {
  let variable1 = Double.random(in: 0...1)
  let variable2 = Double.random(in: 0...1)
  let multiplier = sqrt(-2 * log(variable1)) * cos(2 * .pi * variable2)

  return Int(multiplier * standardDeviation + mean)
}

// This function accepts two arrays and returns a 2D array.
func generateMarks(students: [String], assignments: [String]) -> [[String]] {
  // Declare variables and arrays for function.
  var studentMarks = [[String]](repeating: [String](repeating: "", count: assignments.count + 1), count: students.count + 1)
  var counter = 0
  var num = 0

  // Fill out header row.
  studentMarks[0][0] = "Name"
  for position in 0..<assignments.count {
    studentMarks[0][position + 1] = assignments[position]
  }

  // Generate marks and assign them to students.
  for student in students {
    studentMarks[counter + 1][0] = student
    for counter2 in 1...assignments.count {
      // Ensure that only numbers between 0 and 100 are generated.
      repeat {
        num = randomNormalValue(mean: 75, standardDeviation: 10)
      } while num < 0 || num > 100
      studentMarks[counter + 1][counter2] = String(num)
    }
    counter = counter + 1
  }

  // Return 2D array.
  return studentMarks
}

// Read in student names from students.txt
let studentFile = URL(fileURLWithPath: "Unit1-08-students.txt")
let studentData = try String(contentsOf: studentFile)
let studentArray = studentData.components(separatedBy: .newlines)

// Read in assignment names from assignments.txt
let assignmentFile = URL(fileURLWithPath: "Unit1-08-assignments.txt")
let assignmentData = try String(contentsOf: assignmentFile)
let assignmentArray = assignmentData.components(separatedBy: .newlines)

// Open the output file for writing.
let outputFile = URL(fileURLWithPath: "output.csv")

// This appears to be a far more consistent and efficient method
// of file reading and writing than what I was using earlier.

// Call functions for math.
let marksArray = generateMarks(students: studentArray, assignments: assignmentArray)

// Join each element in row with commas, and separate each row with newlines.
let marksString = marksArray.map { $0.joined(separator: ", ") }.joined(separator: "\n")

// Print results.
print(marksString)

// Write results to output 
try marksString.write(to: outputFile, atomically: true, encoding: .utf8)
