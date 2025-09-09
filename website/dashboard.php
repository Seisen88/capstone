<?php
session_start();
if (!isset($_SESSION['user_id'])) {
    header('Location: index.php');
    exit;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link rel="stylesheet" href="dashboard.css">
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header">
            <img src="../images/binhi.png" alt="BINHI Logo" class="sidebar-logo">
        </div>
        <nav class="main-menu">
            <a href="dashboard.php" class="active">
                <span class="icon"><img src="../images/dashboard.png" alt="Dashboard" style="width:40px; vertical-align:right; margin-right:8px;"></span>
                Dashboard
            </a>
            <a href="farmer.php">
                <span class="icon"><img src="../images/verification.png" alt="Farmer" style="width:25px; vertical-align:right; margin-right:8px;"></span>
                Farmer
            </a>
            <a href="#">
                <span class="icon"><img src="../images/coop.png" alt="Cooperative Management" style="width:20px; vertical-align:right; margin-right:8px;"></span>
                Cooperative Management
            </a>
            <a href="#">
                <span class="icon"><img src="../images/subsidies.png" alt="Subsidies" style="width:30px; vertical-align:right; margin-right:8px;"></span>
                Subsidies
            </a>
            <a href="#">
                <span class="icon"><img src="../images/reports.png" alt="Reports" style="width:20px; vertical-align:right; margin-right:8px;"></span>
                Reports
            </a>
        </nav>
        <div class="sidebar-section">
            <img src="../images/farmer.png" alt="User Avatar">
            <div class="sidebar-user"><?= htmlspecialchars($_SESSION['username']) ?></div>
            <div class="sidebar-role">Farmer</div>
            <nav class="account-menu">
                <a href="#">Profile</a>
                <a href="logout.php" class="btn btn-danger" style="width:100%">Log out</a>
            </nav>
        </div>
    </div>
    <div class="main-content">
        <div class="top-header">
            <div>
                <span class="dashboard-title">BINHI / <span class="dashboard-highlight">Dashboard</span></span>
            </div>
            <div class="dashboard-user-info">
                <span class="dashboard-role">ADMIN</span>
                <span class="dashboard-settings">⚙️</span>
            </div>
        </div>
        <div class="dashboard-cards">
            <div class="card">
                <hr class="card-top-line">
                <div class="card-group">
                    <div class="card-item">
                        <div class="card-header">
                            <span class="card-icon card-icon-green">🌱</span>
                            <div>
                                <div class="card-title">Total Seed Allocations</div>
                                <div class="card-value">1,250</div>
                            </div>
                        </div>
                    </div>
                    <div class="card-item">
                        <div class="card-header">
                            <span class="card-icon card-icon-blue">👨‍🌾</span>
                            <div>
                                <div class="card-title">Verified Farmers</div>
                                <div class="card-value">248</div>
                            </div>
                        </div>
                    </div>
                    <div class="card-item">
                        <div class="card-header">
                            <span class="card-icon card-icon-purple">🏢</span>
                            <div>
                                <div class="card-title">Cooperative Members</div>
                                <div class="card-value">12</div>
                            </div>
                        </div>
                    </div>
                </div>
                <hr class="card-bottom-line">
                <div class="card-actions">
                    <button class="complete-report-btn">View Complete Report</button>
                </div>
            </div>
            <!-- Centered Graph and Timeline Section -->
            <div class="dashboard-center-row" style="display: flex; gap: 32px; margin-top: 16px;">
                <!-- Graph Card -->
                <div class="card graph-card modern-card">
                    <div class="modern-card-header">
                        <span class="modern-card-icon">📈</span>
                        <span class="modern-card-title">Technical Support</span>
                        <span class="modern-card-menu">⋮</span>
                    </div>
                    <div class="modern-divider"></div>
                    <div class="graph-stats-row">
                        <div class="graph-stat">
                            <span class="graph-stat-label">NEW ACCOUNTS SINCE 2018</span>
                            <span class="graph-stat-value graph-up">↑ 78%</span>
                            <span class="graph-stat-change graph-up">+14</span>
                        </div>
                    </div>
                    <div class="graph-area modern-graph-area">
                        <canvas id="seedGrowthChart" style="width:100%;max-width:540px;height:120px;"></canvas>
                    </div>
                    <div class="graph-progress-row">
                        <span class="graph-progress-label">Total Orders</span>
                        <span class="graph-progress-value" style="color:#4ad991;font-size:20px;font-weight:700;">$1896</span>
                    </div>
                    <div class="graph-progress-row">
                        <span class="graph-progress-label">YoY Growth</span>
                        <div class="graph-progress-bar"><div class="graph-progress-fill" style="width:78%;"></div></div>
                        <span class="graph-progress-value">100%</span>
                    </div>
                </div>
                <!-- Timeline Chat Card -->
                <div class="card support-card modern-card">
                    <div class="modern-card-header">
                        <span class="modern-card-icon">🕒</span>
                        <span class="modern-card-title">Timeline Example</span>
                        <span class="modern-card-menu">⋮</span>
                    </div>
                    <div class="modern-divider"></div>
                    <div class="timeline-vertical">
                        <div class="timeline-event">
                            <span class="timeline-dot timeline-dot-red"></span>
                            <div class="timeline-details">
                                <span class="timeline-title">All Hands Meeting</span>
                                <span class="timeline-desc">Yet another one, at <span class="timeline-time">15:00 PM</span></span>
                            </div>
                        </div>
                        <div class="timeline-event">
                            <span class="timeline-dot timeline-dot-green"></span>
                            <div class="timeline-details">
                                <span class="timeline-title">Build the production release <span class="timeline-badge">NEW</span></span>
                                <span class="timeline-desc">Build the production release</span>
                            </div>
                        </div>
                        <div class="timeline-event">
                            <span class="timeline-dot timeline-dot-yellow"></span>
                            <div class="timeline-details">
                                <span class="timeline-title">Something not important</span>
                                <span class="timeline-avatars">
                                    <img src="../images/farmer.png" class="timeline-avatar" alt="Avatar">
                                    <img src="../images/farmer.png" class="timeline-avatar" alt="Avatar">
                                    <img src="../images/farmer.png" class="timeline-avatar" alt="Avatar">
                                    <img src="../images/farmer.png" class="timeline-avatar" alt="Avatar">
                                    <img src="../images/farmer.png" class="timeline-avatar" alt="Avatar">
                                </span>
                            </div>
                        </div>
                        <div class="timeline-event">
                            <span class="timeline-dot timeline-dot-blue"></span>
                            <div class="timeline-details">
                                <span class="timeline-title">This dot has an info state</span>
                            </div>
                        </div>
                        <div class="timeline-event">
                            <span class="timeline-dot timeline-dot-dark"></span>
                            <div class="timeline-details">
                                <span class="timeline-title">This dot has a dark state</span>
                            </div>
                        </div>
                    </div>
                    <div class="timeline-actions" style="margin-top:auto;">
                        <button class="timeline-btn">View All Messages</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<script>
    const ctx = document.getElementById('seedGrowthChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
            datasets: [{
                label: 'Seed Allocations',
                data: [120, 150, 180, 170, 210, 250, 300],
                borderColor: '#4ad991',
                backgroundColor: 'rgba(74,217,145,0.08)',
                fill: true,
                tension: 0.4,
                pointRadius: 0,
                borderWidth: 3
            }]
        },
        options: {
            plugins: {
                legend: { display: false }
            },
            scales: {
                x: {
                    grid: { display: false },
                    ticks: { color: '#888' }
                },
                y: {
                    grid: { color: '#f0f0f0' },
                    ticks: { color: '#888' }
                }
            }
        }
    });
</script>
</html>
