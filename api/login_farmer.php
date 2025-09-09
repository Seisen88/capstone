<?php
header('Content-Type: application/json');
include '../database/db_connect.php';

$data = json_decode(file_get_contents('php://input'), true);

$username = $data['username'];
$password = $data['password'];


$stmt = $conn->prepare('SELECT password, is_verified FROM farmer WHERE username = ?');
$stmt->bind_param('s', $username);
$stmt->execute();
$stmt->bind_result($hashed_password, $is_verified);

if ($stmt->fetch() && password_verify($password, $hashed_password)) {
    echo json_encode(['success' => true, 'is_verified' => $is_verified]);
} else {
    echo json_encode(['success' => false]);
}
$stmt->close();
$conn->close();
?>
