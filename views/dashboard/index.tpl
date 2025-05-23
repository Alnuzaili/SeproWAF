<!-- Dashboard Header with Welcome Message and Key Metrics -->
<div class="w-full">
    <!-- Dashboard Header -->
    <div class="flex flex-wrap items-center justify-between mb-8">
        <div>
            <h1 class="text-2xl font-bold text-slate-800">Overview</h1>
        </div>
        <div class="relative">
            <input type="text" placeholder="Search for something" class="pl-10 pr-4 py-2 border border-gray-300 rounded-lg bg-white text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500">
            <svg class="absolute left-3 top-2.5 h-4 w-4 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
        </div>
    </div>

    <!-- Key Metrics Cards - Row 1 -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <!-- Total Balance Card -->
        <div class="bg-indigo-600 text-white rounded-lg shadow-md p-6 relative overflow-hidden">
            <div class="flex flex-col">
                <span class="text-indigo-200 text-sm font-medium mb-2">Total Protected Sites</span>
                <div class="flex items-center">
                    <span class="text-2xl font-bold mr-2" id="sites-count">--</span>
                </div>
                <span class="text-xs text-indigo-200 mt-2">↑ 3.5% from last month</span>
            </div>
            <div class="absolute right-4 top-4">
                <i class="bi bi-shield text-3xl text-indigo-400 opacity-70"></i>
            </div>
        </div>

        <!-- Accounts Card -->
        <div class="bg-white rounded-lg shadow-md p-6 relative overflow-hidden border border-gray-100">
            <div class="flex flex-col">
                <span class="text-gray-500 text-sm font-medium mb-2">Active Custom Rules</span>
                <div class="flex items-center">
                    <span class="text-2xl font-bold text-gray-800" id="rules-count">--</span>
                </div>
                <div class="flex items-center text-xs text-gray-500 mt-2">
                    <span>↑ <span id="default-rules-count">--</span> Default</span>
                    <span class="mx-2">•</span>
                    <span class="text-orange-500">↑ <span id="custom-rules-count">--</span> Custom</span>
                </div>
            </div>
            <div class="absolute right-4 top-4">
                <i class="bi bi-shield-check text-3xl text-orange-400 opacity-70"></i>
            </div>
        </div>

        <!-- Loan Disbursed Card -->
        <div class="bg-white rounded-lg shadow-md p-6 relative overflow-hidden border border-gray-100">
            <div class="flex flex-col">
                <span class="text-gray-500 text-sm font-medium mb-2">Total Blocked Attacks</span>
                <div class="flex items-center">
                    <span class="text-2xl font-bold text-gray-800" id="attacks-count">--</span>
                </div>
                <div class="flex items-center text-xs text-gray-500 mt-2">
                    <span>↑ 03 Today</span>
                    <span class="mx-2">•</span>
                    <span class="text-red-500">↑ 02 Critical</span>
                </div>
            </div>
            <div class="absolute right-4 top-4">
                <i class="bi bi-shield-x text-3xl text-blue-400 opacity-70"></i>
            </div>
        </div>

        <!-- Staff Activity Card -->
        <div class="bg-white rounded-lg shadow-md p-6 relative overflow-hidden border border-gray-100">
            <div class="flex flex-col">
                <span class="text-gray-500 text-sm font-medium mb-2">Total Requests</span>
                <div class="flex items-center">
                    <span class="text-2xl font-bold text-gray-800" id="requests-count">--</span>
                </div>
                <div class="flex items-center text-xs text-gray-500 mt-2">
                    <span>↑ 12 Present</span>
                    <span class="mx-2">•</span>
                    <span class="text-green-500">↑ 03 Success</span>
                </div>
            </div>
            <div class="absolute right-4 top-4">
                <i class="bi bi-globe text-3xl text-green-400 opacity-70"></i>
            </div>
        </div>
    </div>

    <!-- Main Content Area -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Left Column (2/3 width) -->
        <div class="lg:col-span-2 space-y-6">
            <!-- Traffic Report Card -->
            <div class="bg-white rounded-lg shadow-sm border border-gray-100">
                <div class="p-6 border-b border-gray-100">
                    <div class="flex justify-between items-center">
                        <h2 class="text-lg font-semibold text-gray-800">Traffic Report</h2>
                        <div class="flex space-x-2">
                            <button class="px-3 py-1 text-xs bg-indigo-500 text-white rounded-md active">Daily</button>
                            <button class="px-3 py-1 text-xs text-gray-500 hover:bg-gray-100 rounded-md">Weekly</button>
                            <button class="px-3 py-1 text-xs text-gray-500 hover:bg-gray-100 rounded-md">Monthly</button>
                            <button class="ml-2 p-1 text-gray-400 hover:text-indigo-500">
                                <i class="bi bi-download"></i>
                                <span class="ml-1 text-xs">Export</span>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="p-6">
                    <canvas id="trafficChart" class="h-[300px]"></canvas>
                </div>
            </div>

            <!-- New Chart: Top Attacked Sites -->
            <div class="bg-white rounded-lg shadow-sm border border-gray-100">
                <div class="p-6 border-b border-gray-100">
                    <div class="flex justify-between items-center">
                        <h2 class="text-lg font-semibold text-gray-800">Top Attacked Sites</h2>
                        <div class="flex space-x-2">
                            <button class="px-3 py-1 text-xs bg-blue-500 text-white rounded-md active">7 Days</button>
                            <button class="px-3 py-1 text-xs text-gray-500 hover:bg-gray-100 rounded-md">30 Days</button>
                            <button class="ml-2 p-1 text-gray-400 hover:text-blue-500">
                                <i class="bi bi-info-circle"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="p-6">
                    <canvas id="topAttackedSitesChart" class="h-[300px]"></canvas>
                </div>
            </div>

            <!-- Attack Time Patterns -->
            <div class="bg-white rounded-lg shadow-sm border border-gray-100">
                <div class="p-6 border-b border-gray-100">
                    <div class="flex justify-between items-center">
                        <h2 class="text-lg font-semibold text-gray-800">Attack Time Patterns</h2>
                        <div class="flex space-x-2">
                            <span class="text-sm text-gray-500">Last 7 days</span>
                        </div>
                    </div>
                </div>
                <div class="p-6">
                    <canvas id="attacksByHourChart" class="h-[300px]"></canvas>
                </div>
            </div>

            <!-- Latest Transaction Card -->
            <div class="bg-white rounded-lg shadow-sm border border-gray-100">
                <div class="p-6 border-b border-gray-100">
                    <div class="flex justify-between items-center">
                        <h2 class="text-lg font-semibold text-gray-800">Latest Security Events</h2>
                        <a href="/waf/logs" class="text-indigo-500 text-sm hover:text-indigo-600">View All</a>
                    </div>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50 text-xs font-medium text-gray-500 uppercase tracking-wider">
                            <tr>
                                <th class="px-6 py-3 text-left">Type</th>
                                <th class="px-6 py-3 text-left">Source IP</th>
                                <th class="px-6 py-3 text-left">Site</th>
                                <th class="px-6 py-3 text-right">Value</th>
                            </tr>
                        </thead>
                        <tbody id="recent-attacks" class="divide-y divide-gray-200 bg-white text-sm text-gray-700">
                            <tr>
                                <td colspan="4" class="text-center py-4">Loading...</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Right Column (1/3 width) -->
        <div class="space-y-6">
            <!-- Attack Types Chart -->
            <div class="bg-white rounded-lg shadow-sm border border-gray-100">
                <div class="p-6 border-b border-gray-100">
                    <h2 class="text-lg font-semibold text-gray-800">Attack Types</h2>
                </div>
                <div class="p-6">
                    <canvas id="attackTypesChart" class="h-[250px]"></canvas>
                </div>
            </div>

            <!-- NEW: Geographic Attack Origin -->
            <div class="bg-white rounded-lg shadow-sm border border-gray-100">
                <div class="p-6 border-b border-gray-100">
                    <h2 class="text-lg font-semibold text-gray-800">Geographic Attack Origin</h2>
                </div>
                <div class="p-6">
                    <canvas id="geoAttackChart" class="h-[300px]"></canvas>
                </div>
            </div>

            <!-- Quick Actions List -->
            <div class="bg-white rounded-lg shadow-sm border border-gray-100">
                <div class="p-6 border-b border-gray-100">
                    <h2 class="text-lg font-semibold text-gray-800">Quick Actions</h2>
                </div>
                <div class="p-4">
                    <div class="flex flex-col space-y-3">
                        <!-- Add New Site Action -->
                        <a href="/waf/sites/new" class="group flex items-center p-3 rounded-lg hover:bg-gray-50">
                            <div class="flex-shrink-0 rounded-lg p-2 bg-indigo-50 group-hover:bg-indigo-100">
                                <i class="bi bi-plus-circle text-indigo-500 text-lg"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-800">Add New Site</p>
                                <p class="text-xs text-gray-500">Add a new site to protect</p>
                            </div>
                            <i class="bi bi-chevron-right ml-auto text-gray-400"></i>
                        </a>

                        <!-- View Security Logs Action -->
                        <a href="/waf/logs" class="group flex items-center p-3 rounded-lg hover:bg-gray-50">
                            <div class="flex-shrink-0 rounded-lg p-2 bg-orange-50 group-hover:bg-orange-100">
                                <i class="bi bi-shield text-orange-500 text-lg"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-800">Security Logs</p>
                                <p class="text-xs text-gray-500">View detailed security logs</p>
                            </div>
                            <i class="bi bi-chevron-right ml-auto text-gray-400"></i>
                        </a>

                        <!-- Custom Rules Action -->
                        <a href="/waf/rules" class="group flex items-center p-3 rounded-lg hover:bg-gray-50">
                            <div class="flex-shrink-0 rounded-lg p-2 bg-blue-50 group-hover:bg-blue-100">
                                <i class="bi bi-gear text-blue-500 text-lg"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-800">Custom Rules</p>
                                <p class="text-xs text-gray-500">Manage WAF security rules</p>
                            </div>
                            <i class="bi bi-chevron-right ml-auto text-gray-400"></i>
                        </a>

                        <!-- SSL Certificates Action -->
                        <a href="/waf/certificates" class="group flex items-center p-3 rounded-lg hover:bg-gray-50">
                            <div class="flex-shrink-0 rounded-lg p-2 bg-green-50 group-hover:bg-green-100">
                                <i class="bi bi-file-earmark-lock text-green-500 text-lg"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-800">SSL Certificates</p>
                                <p class="text-xs text-gray-500">Manage TLS certificates</p>
                            </div>
                            <i class="bi bi-chevron-right ml-auto text-gray-400"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Protection Status Card -->
            <div class="bg-white rounded-lg shadow-sm border border-gray-100">
                <div class="p-6 border-b border-gray-100">
                    <h2 class="text-lg font-semibold text-gray-800">Protection Status</h2>
                </div>
                <div class="p-6">
                    <p class="text-sm font-medium text-gray-600 mb-2">System Health</p>
                    <div class="flex items-center">
                        <div class="w-full bg-gray-200 rounded-full h-2">
                            <div class="bg-green-500 h-2 rounded-full" style="width: 95%"></div>
                        </div>
                        <span class="ml-4 text-sm font-semibold text-green-500">95%</span>
                    </div>
                    <p class="text-xs text-gray-500 mt-2">All security systems operational</p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- New Full-Width Row: Additional Charts -->
    <div class="mt-6">
        <div class="grid grid-cols-1 gap-6">
            <!-- Security Insights Card -->
            <div class="bg-white rounded-lg shadow-sm border border-gray-100">
                <div class="p-6 border-b border-gray-100">
                    <div class="flex justify-between items-center">
                        <h2 class="text-lg font-semibold text-gray-800">Security Analysis</h2>
                        <div>
                            <button class="px-3 py-2 bg-indigo-500 text-white rounded-md text-sm hover:bg-indigo-600">
                                <i class="bi bi-file-earmark-text mr-1"></i> Generate Report
                            </button>
                        </div>
                    </div>
                </div>
                <div class="p-6">
                    <div class="bg-blue-50 border-l-4 border-blue-400 p-4 mb-6">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i class="bi bi-info-circle text-blue-400"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm text-blue-700">
                                    Security analysis is based on data collected over the past 30 days. The system has detected patterns that may require attention.
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="border border-gray-200 rounded-lg p-4">
                            <h3 class="font-medium text-gray-800 mb-2">Attack Trend Analysis</h3>
                            <p class="text-sm text-gray-600 mb-3">Overall attack attempts have <span class="text-red-500 font-medium">increased by 12%</span> compared to previous period.</p>
                            <div class="flex items-center">
                                <div id="sparkline-attacks" class="flex-grow"></div>
                            </div>
                        </div>
                        <div class="border border-gray-200 rounded-lg p-4">
                            <h3 class="font-medium text-gray-800 mb-2">Protection Efficiency</h3>
                            <p class="text-sm text-gray-600 mb-3">WAF rules are currently blocking <span class="text-green-500 font-medium">98.7%</span> of malicious requests.</p>
                            <div class="w-full bg-gray-200 rounded-full h-2.5 mb-2">
                                <div class="bg-green-500 h-2.5 rounded-full" style="width: 98.7%"></div>
                            </div>
                            <div class="text-xs text-gray-500 flex justify-between">
                                <span>0%</span>
                                <span>50%</span>
                                <span>100%</span>
                            </div>
                        </div>
                        <div class="border border-gray-200 rounded-lg p-4">
                            <h3 class="font-medium text-gray-800 mb-2">Risk Assessment</h3>
                            <p class="text-sm text-gray-600 mb-3">Current security risk level is <span class="text-yellow-500 font-medium">Medium</span>.</p>
                            <div class="flex items-center justify-between text-sm">
                                <div class="flex items-center">
                                    <div class="w-3 h-3 rounded-full bg-green-500 mr-1"></div>
                                    <span class="text-gray-600">Low</span>
                                </div>
                                <div class="flex items-center">
                                    <div class="w-3 h-3 rounded-full bg-yellow-500 mr-1"></div>
                                    <span class="text-yellow-600 font-medium">Medium</span>
                                </div>
                                <div class="flex items-center">
                                    <div class="w-3 h-3 rounded-full bg-red-500 mr-1"></div>
                                    <span class="text-gray-600">High</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Check if we're authenticated
    if (!isLoggedIn()) {
        showToast('Please login to continue', 'warning');
        setTimeout(() => {
            window.location.href = '/auth/login';
        }, 1000);
        return;
    }
    
    // If we're authenticated, load dashboard data
    const userData = getUserData();
    if (userData) {
        // Set user name in UI if needed
        if (document.querySelector('.username-display')) {
            document.querySelector('.username-display').textContent = userData.username;
        }
    }

    // Fetch dashboard data
    async function fetchDashboardData() {
        try {
            // Fetch dashboard stats
            const stats = await api.get('/dashboard/stats');
            if (stats.data && stats.data.success) {
                document.getElementById('sites-count').textContent = stats.data.sites_count || '0';
                document.getElementById('attacks-count').textContent = stats.data.attacks_count || '0';
                document.getElementById('requests-count').textContent = stats.data.requests_count || '0';
                
                // Use actual rules count data
                document.getElementById('rules-count').textContent = stats.data.rules_count || '0';
                document.getElementById('default-rules-count').textContent = stats.data.default_rules || '0';
                document.getElementById('custom-rules-count').textContent = stats.data.custom_rules || '0';
            }
            
            // Get traffic data for the chart
            const trafficData = await api.get('/dashboard/traffic');
            if (trafficData.data && trafficData.data.success) {
                renderTrafficChart(trafficData.data.traffic);
            } else {
                renderTrafficChart(null);
            }
            
            // Get attack type distribution
            const attackTypesData = await api.get('/dashboard/attack-types');
            if (attackTypesData.data && attackTypesData.data.success) {
                renderAttackTypesChart(attackTypesData.data.attack_types);
            } else {
                renderAttackTypesChart(null);
            }
            
            // Get recent attacks
            const recentAttacksData = await api.get('/waf/logs', {
                params: {
                    page: 1,
                    page_size: 5,
                    action: 'blocked'
                }
            });
            
            if (recentAttacksData.data && recentAttacksData.data.success) {
                renderRecentAttacks(recentAttacksData.data.data);
            } else {
                renderRecentAttacks([]);
            }
            
            // NEW: Get top attacked sites
            const topSitesData = await api.get('/dashboard/top-attacked-sites');
            if (topSitesData.data && topSitesData.data.success) {
                renderTopAttackedSitesChart(topSitesData.data.top_attacked_sites);
            } else {
                renderTopAttackedSitesChart(null);
            }
            
            // NEW: Get attacks by hour
            const attacksByHourData = await api.get('/dashboard/attacks-by-hour');
            if (attacksByHourData.data && attacksByHourData.data.success) {
                renderAttacksByHourChart(attacksByHourData.data.attacks_by_hour);
            } else {
                renderAttacksByHourChart(null);
            }
            
            // NEW: Get geographic attack distribution
            const geoData = await api.get('/dashboard/geo-distribution');
            if (geoData.data && geoData.data.success) {
                renderGeoAttackChart(geoData.data.geo_distribution);
            } else {
                renderGeoAttackChart(null);
            }
            
            // Render sparkline chart for attack trends
            renderSparkline();
            
        } catch (error) {
            console.error('Error fetching dashboard data:', error);
            showToast('Failed to load dashboard data', 'danger');
        }
    }
    
    // Traffic chart
    function renderTrafficChart(data) {
        const ctx = document.getElementById('trafficChart').getContext('2d');
        
        // Use actual data if available, otherwise use placeholder data
        const labels = data?.labels || ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        
        const chartData = {
            labels: labels,
            datasets: [
                {
                    label: 'Legitimate Traffic',
                    data: data?.legitimate || [320, 280, 300, 250, 400, 380, 340],
                    borderColor: '#4F46E5',
                    backgroundColor: 'rgba(79, 70, 229, 0.05)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4
                },
                {
                    label: 'Blocked Attacks',
                    data: data?.blocked || [20, 40, 15, 35, 25, 30, 20],
                    borderColor: '#EF4444',
                    backgroundColor: 'rgba(239, 68, 68, 0.05)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4
                }
            ]
        };
        
        new Chart(ctx, {
            type: 'line',
            data: chartData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0, 0, 0, 0.05)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                },
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            boxWidth: 10,
                            usePointStyle: true,
                            pointStyle: 'circle'
                        }
                    }
                },
                interaction: {
                    mode: 'index',
                    intersect: false
                }
            }
        });
    }
    
    // Attack types chart
    function renderAttackTypesChart(data) {
        const ctx = document.getElementById('attackTypesChart').getContext('2d');
        
        // Use actual data if available, otherwise use placeholder data
        const labels = data?.labels || ['SQL Injection', 'XSS', 'CSRF', 'Path Traversal', 'Other'];
        const values = data?.values || [45, 25, 12, 8, 10];
        
        const chartData = {
            labels: labels,
            datasets: [{
                data: values,
                backgroundColor: [
                    '#4F46E5', // Indigo
                    '#F59E0B', // Amber
                    '#10B981', // Emerald
                    '#3B82F6', // Blue
                    '#8B5CF6'  // Violet
                ],
                borderWidth: 0
            }]
        };
        
        new Chart(ctx, {
            type: 'doughnut',
            data: chartData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '70%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            boxWidth: 12,
                            padding: 15,
                            usePointStyle: true,
                            pointStyle: 'circle'
                        }
                    }
                }
            }
        });
    }
    
    // Recent attacks table
    function renderRecentAttacks(attacks) {
        const tbody = document.getElementById('recent-attacks');
        tbody.innerHTML = '';
        
        if (!attacks || attacks.length === 0) {
            const tr = document.createElement('tr');
            tr.innerHTML = `<td colspan="4" class="text-center py-4 text-gray-500">No recent security events</td>`;
            tbody.appendChild(tr);
            return;
        }
        
        attacks.forEach(attack => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td class="px-6 py-4">
                    <div class="flex items-center">
                        <div class="h-8 w-8 flex-shrink-0 rounded-full bg-red-100 flex items-center justify-center">
                            <i class="bi bi-shield-exclamation text-red-500"></i>
                        </div>
                        <div class="ml-4">
                            <div class="text-sm font-medium">${attack.Category || attack.category || 'Unknown'}</div>
                            <div class="text-xs text-gray-500">${formatDate(attack.CreatedAt || attack.created_at)}</div>
                        </div>
                    </div>
                </td>
                <td class="px-6 py-4">
                    <span class="text-sm">${attack.ClientIP || attack.client_ip}</span>
                </td>
                <td class="px-6 py-4">
                    <span class="text-sm">${attack.Domain || attack.domain || 'Unknown'}</span>
                </td>
                <td class="px-6 py-4 text-right">
                    <span class="inline-flex rounded-full bg-red-100 px-2 py-1 text-xs font-semibold text-red-700">Blocked</span>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
    
    // NEW: Top Attacked Sites chart
    function renderTopAttackedSitesChart(data) {
        const ctx = document.getElementById('topAttackedSitesChart').getContext('2d');
        
        // Use actual data if available, otherwise use placeholder data
        const labels = data?.labels || ['example.com', 'test-site.org', 'company.net', 'api.domain.com', 'static.cdn.net'];
        const values = data?.values || [0, 0, 0, 0, 0];
        
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Attack Count',
                    data: values,
                    backgroundColor: 'rgba(37, 99, 235, 0.7)',
                    borderColor: 'rgba(37, 99, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Number of Attacks'
                        },
                        ticks: {
                            precision: 0
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Website Domain'
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return `Attacks: ${context.parsed.y}`;
                            }
                        }
                    }
                }
            }
        });
    }
    
    // NEW: Attacks by Hour chart
    function renderAttacksByHourChart(data) {
        const ctx = document.getElementById('attacksByHourChart').getContext('2d');
        
        // Use actual data if available, otherwise use placeholder data
        const labels = data?.labels || Array.from({length: 24}, (_, i) => `${i.toString().padStart(2, '0')}:00`);
        const values = data?.values || Array(24).fill(0);
        
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Attacks',
                    data: values,
                    borderColor: 'rgba(234, 88, 12, 1)',
                    backgroundColor: 'rgba(234, 88, 12, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.3,
                    pointRadius: 3,
                    pointBackgroundColor: 'rgba(234, 88, 12, 1)'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Number of Attacks'
                        },
                        ticks: {
                            precision: 0
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Hour of Day (24h)'
                        },
                        ticks: {
                            maxRotation: 0,
                            autoSkip: true,
                            maxTicksLimit: 12
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            title: function(context) {
                                return `Time: ${context[0].label}`;
                            },
                            label: function(context) {
                                return `Attacks: ${context.parsed.y}`;
                            }
                        }
                    }
                }
            }
        });
    }
    
    // NEW: Geographic Attack Distribution chart
    function renderGeoAttackChart(data) {
        const ctx = document.getElementById('geoAttackChart').getContext('2d');
        
        // Use actual data if available, otherwise use placeholder data
        const labels = data?.labels || ['Unknown'];
        const values = data?.values || [0];
        
        new Chart(ctx, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    data: values,
                    backgroundColor: [
                        '#3B82F6', // blue
                        '#F59E0B', // amber
                        '#10B981', // emerald
                        '#EF4444', // red
                        '#8B5CF6', // violet
                        '#EC4899', // pink
                        '#6366F1', // indigo
                        '#14B8A6', // teal
                        '#F97316', // orange
                        '#A855F7'  // purple
                    ],
                    borderWidth: 1,
                    borderColor: '#ffffff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            boxWidth: 12,
                            padding: 15,
                            usePointStyle: true,
                            pointStyle: 'circle'
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.parsed || 0;
                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                const percentage = ((value / total) * 100).toFixed(1);
                                return `${label}: ${value} (${percentage}%)`;
                            }
                        }
                    }
                }
            }
        });
    }
    
    // NEW: Sparkline chart for attack trends
    function renderSparkline() {
        // Sample data - in a real app, this would come from the API
        const sparklineData = [12, 15, 10, 18, 29, 23, 32, 30, 25, 28];
        
        const options = {
            chart: {
                type: 'line',
                height: 40,
                width: '100%',
                sparkline: {
                    enabled: true
                },
                animations: {
                    enabled: true,
                    easing: 'easeinout',
                    speed: 800
                }
            },
            series: [{
                name: 'Attacks',
                data: sparklineData
            }],
            stroke: {
                width: 2,
                curve: 'smooth'
            },
            colors: ['#EF4444'], // Red color
            tooltip: {
                fixed: {
                    enabled: false
                },
                x: {
                    show: false
                },
                y: {
                    title: {
                        formatter: function() {
                            return 'Attacks:';
                        }
                    }
                },
                marker: {
                    show: false
                }
            }
        };
        
        const chart = new ApexCharts(document.querySelector("#sparkline-attacks"), options);
        chart.render();
    }
    
    // Helper function to format date
    function formatDate(dateString) {
        if (!dateString) return '--';
        const date = new Date(dateString);
        return date.toLocaleString();
    }
    
    // Load dashboard data
    fetchDashboardData();
});
</script>