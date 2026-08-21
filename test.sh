#!/bin/bash

MYSQL="mysql -h127.0.0.1 -P3306 -uroot -proot"

echo "========================================"
echo " INSERT Records - Student Table"
echo "========================================"

# Check student solution file
if [ ! -f "student_solution.sql" ]; then
    echo "FAIL: student_solution.sql file not found."
    exit 1
fi

echo "Creating fresh CollegeDB database..."

# Create fresh database
$MYSQL -e "DROP DATABASE IF EXISTS CollegeDB;"
$MYSQL -e "CREATE DATABASE CollegeDB;"

echo "Creating Student table..."

# Create original Student table
$MYSQL CollegeDB -e "
CREATE TABLE Student (
    StudentID INT(5) PRIMARY KEY,
    StudentName VARCHAR(20),
    Gender VARCHAR(10),
    DepartmentID INT(5)
);
"

echo "Executing student_solution.sql..."

# Execute student SQL
if ! $MYSQL CollegeDB < student_solution.sql; then
    echo "FAIL: Error while executing student_solution.sql"
    exit 1
fi

echo ""
echo "Checking inserted records..."
echo ""

MARKS=0

# ----------------------------------------
# Test Case 1: Arun record
# ----------------------------------------

RESULT=$($MYSQL -N -s CollegeDB -e "
SELECT COUNT(*)
FROM Student
WHERE StudentID=1001
AND StudentName='Arun'
AND Gender='Male'
AND DepartmentID=101;
")

if [ "$RESULT" -eq 1 ]; then
    echo "PASS: Arun record inserted correctly."
    MARKS=$((MARKS+3))
else
    echo "FAIL: Arun record is missing or incorrect."
fi

# ----------------------------------------
# Test Case 2: Divya record
# ----------------------------------------

RESULT=$($MYSQL -N -s CollegeDB -e "
SELECT COUNT(*)
FROM Student
WHERE StudentID=1002
AND StudentName='Divya'
AND Gender='Female'
AND DepartmentID=102;
")

if [ "$RESULT" -eq 1 ]; then
    echo "PASS: Divya record inserted correctly."
    MARKS=$((MARKS+3))
else
    echo "FAIL: Divya record is missing or incorrect."
fi

# ----------------------------------------
# Test Case 3: Karthik record
# ----------------------------------------

RESULT=$($MYSQL -N -s CollegeDB -e "
SELECT COUNT(*)
FROM Student
WHERE StudentID=1003
AND StudentName='Karthik'
AND Gender='Male'
AND DepartmentID=101;
")

if [ "$RESULT" -eq 1 ]; then
    echo "PASS: Karthik record inserted correctly."
    MARKS=$((MARKS+3))
else
    echo "FAIL: Karthik record is missing or incorrect."
fi

# ----------------------------------------
# Test Case 4: Total records
# ----------------------------------------

TOTAL=$($MYSQL -N -s CollegeDB -e "
SELECT COUNT(*)
FROM Student;
")

if [ "$TOTAL" -ge 3 ]; then
    echo "PASS: Student records inserted."
    MARKS=$((MARKS+1))
else
    echo "FAIL: Less than 3 records found."
fi

echo ""
echo "========================================"
echo "Student Table Records"
echo "========================================"

$MYSQL CollegeDB -e "SELECT * FROM Student;"

echo ""
echo "========================================"
echo "Total Marks: $MARKS / 10"
echo "========================================"

if [ "$MARKS" -eq 10 ]; then
    echo "SUCCESS: All test cases passed."
    exit 0
else
    echo "Some test cases failed."
    exit 1
fi
