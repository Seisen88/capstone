<?php
// Database connection
include '../database/db_connect.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verification Logs | BINHI Dashboard</title>
    <link rel="stylesheet" href="dashboard.css">
</head>
<body>
    <div class="sidebar">
        <h2>BINHI Dashboard</h2>
        <nav class="main-menu" style="margin-top:32px;">
            <a href="dashboard.php">Dashboard</a>
            <a href="#">Track Allocation</a>
            <a href="#">Request Seeds</a>
            <a href="#">Settings</a>
            <a href="verification-logs.php" class="active">Verification Logs</a>
        </nav>
    </div>
    <div class="main-content">
        <h1>Farmer Verification Logs</h1>
        <p class="desc">Review and manage farmer verification requests.</p>
        <div class="logs-section">
            <div class="log-entry">
                <span>Farmer John Dela Cruz requests verification.</span>
                <button class="accept-btn">Accept</button>
                <button class="decline-btn">Decline</button>
            </div>
            <div class="log-entry">
                <span>Farmer Maria Santos requests verification.</span>
                <button class="accept-btn">Accept</button>
                <button class="decline-btn">Decline</button>
            </div>
            <!-- More logs can be dynamically loaded here -->
        </div>
    </div>
    <script src="dashboard.js"></script>
</body>
</html>
