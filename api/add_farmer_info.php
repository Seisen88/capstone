<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Content-Type: application/json');
include '../database/db_connect.php';

// Get POST data
$farmer_id = isset($_POST['farmer_id']) ? intval($_POST['farmer_id']) : 0;
$land_size = isset($_POST['land_size']) ? floatval($_POST['land_size']) : null;
$province = isset($_POST['province']) ? $_POST['province'] : null;
$city = isset($_POST['city']) ? $_POST['city'] : null;
$barangay = isset($_POST['barangay']) ? $_POST['barangay'] : null;
$street = isset($_POST['street']) ? $_POST['street'] : null;
$other_info = isset($_POST['other_info']) ? $_POST['other_info'] : null;

// Handle image upload
$image = null;
if (isset($_FILES['image']) && $_FILES['image']['error'] == UPLOAD_ERR_OK) {
    $targetDir = "../images/";
    $fileName = uniqid('farmer_') . "_" . basename($_FILES['image']['name']);
    $targetFile = $targetDir . $fileName;
    if (move_uploaded_file($_FILES['image']['tmp_name'], $targetFile)) {
        $image = $fileName;
    }
}

// Insert information
$stmt = $conn->prepare("INSERT INTO information (farmer_id, land_size, province, city, barangay, street, other_info, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
$stmt->bind_param('idssssss', $farmer_id, $land_size, $province, $city, $barangay, $street, $other_info, $image);

if ($stmt->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'error' => $stmt->error]);
}
?>
