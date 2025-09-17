<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Content-Type: application/json');
include '../database/db_connect.php';

$data = json_decode(file_get_contents('php://input'), true);

$username = $data['username'];
$firstName = $data['first_name'];
$lastName = $data['last_name'];
$password = password_hash($data['password'], PASSWORD_DEFAULT);
$mobile = $data['mobile'];

$stmt = $conn->prepare('INSERT INTO farmer (username, first_name, last_name, password, mobile) VALUES (?, ?, ?, ?, ?)');
$stmt->bind_param('sssss', $username, $firstName, $lastName, $password, $mobile);

if ($stmt->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'error' => $stmt->error]);
}
$stmt->close();
$conn->close();
?>
