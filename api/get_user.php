<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
include '../database/db_connect.php';

$username = $_GET['username'] ?? '';
if (!$username) {
    echo json_encode(['success' => false, 'error' => 'No username provided']);
    exit;
}

$stmt = $conn->prepare('SELECT id, username, first_name, last_name, mobile FROM farmer WHERE username = ?');
$stmt->bind_param('s', $username);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode(['success' => true, 'user' => $row]);
} else {
    echo json_encode(['success' => false, 'error' => 'User not found']);
}
$stmt->close();
$conn->close();
?>
