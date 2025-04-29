<div class="flex flex-wrap mb-4">
    <div class="md:w-1/2">
        <h1>WAF Security Logs</h1>
        <p class="text-gray-600">View security events and blocked attacks</p>
    </div>
    <div class="md:w-1/2 text-right">
        <div class="inline-flex rounded-md shadow-sm" role="group" id="time-range-selector">
            <button type="button" class="px-3 py-2 text-sm font-medium border border-gray-400 text-gray-700 bg-gray-100 rounded-l-md active" data-range="24h">24 Hours</button>
            <button type="button" class="px-3 py-2 text-sm font-medium border-t border-b border-gray-400 text-gray-700 bg-white" data-range="7d">7 Days</button>
            <button type="button" class="px-3 py-2 text-sm font-medium border border-gray-400 text-gray-700 bg-white rounded-r-md" data-range="30d">30 Days</button>
               <button id="summarizeLogsBtn" class="ms-2 px-3 py-2 text-sm font-medium bg-gradient-to-r from-green-600 to-green-700 text-white hover:from-green-700 hover:to-green-800 rounded shadow-sm transition duration-200 flex items-center">
            <span class="flex items-center justify-center bg-white rounded-full w-5 h-5 mr-2">
                <i class="fas fa-robot text-green-600 text-xs"></i>
            </span>
            Analyze with AI
        </button>
        </div>
        <button id="refreshBtn" class="ml-2 px-3 py-2 text-sm font-medium border border-blue-600 text-blue-600 hover:bg-blue-600 hover:text-white rounded">
            <i class="bi bi-arrow-clockwise"></i> Refresh
        </button>

    </div>
</div>

<div class="flex flex-wrap mb-4">
    <div class="w-full">
        <div class="bg-white rounded-lg shadow">
            <div class="px-4 py-3 border-b">
                <h5 class="text-lg font-medium mb-0">Filters</h5>
            </div>
            <div class="p-4">
                <form id="logFilterForm" class="flex flex-wrap">
                    <div class="w-full md:w-1/4 px-2 mb-3">
                        <label for="site_id" class="block text-sm font-medium text-gray-700 mb-1">Site</label>
                        <div class="relative">
                            <select id="site_id" name="site_id" class="block w-full rounded-md border-gray-300 bg-white pl-3 pr-10 py-2 text-base focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-sm appearance-none">
                                <option value="">All Sites</option>
                                <!-- Sites will be loaded dynamically -->
                            </select>
                            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                </svg>
                            </div>
                        </div>
                    </div>
                    <div class="w-full md:w-1/4 px-2 mb-3">
                        <label for="client_ip" class="block text-sm font-medium text-gray-700 mb-1">Client IP</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9-3-9m-9 9a9 9 0 019-9" />
                                </svg>
                            </div>
                            <input type="text" id="client_ip" name="client_ip" class="block w-full pl-10 pr-3 py-2 rounded-md border-gray-300 shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500" placeholder="e.g. 192.168.1.1">
                        </div>
                    </div>
                    <div class="w-full md:w-1/4 px-2 mb-3">
                        <label for="action" class="block text-sm font-medium text-gray-700 mb-1">Action</label>
                        <div class="relative">
                            <select id="action" name="action" class="block w-full rounded-md border-gray-300 bg-white pl-3 pr-10 py-2 text-base focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-sm appearance-none">
                                <option value="">All Actions</option>
                                <option value="allowed">Allowed</option>
                                <option value="blocked">Blocked</option>
                                <option value="blocked_response">Blocked Response</option>
                            </select>
                            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                </svg>
                            </div>
                        </div>
                    </div>
                    <div class="w-full md:w-1/4 px-2 mb-3">
                        <label for="severity" class="block text-sm font-medium text-gray-700 mb-1">Severity</label>
                        <div class="relative">
                            <select id="severity" name="severity" class="block w-full rounded-md border-gray-300 bg-white pl-3 pr-10 py-2 text-base focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-sm appearance-none">
                                <option value="">All Severities</option>
                                <option value="critical">Critical</option>
                                <option value="high">High</option>
                                <option value="medium">Medium</option>
                                <option value="low">Low</option>
                            </select>
                            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                </svg>
                            </div>
                        </div>
                    </div>
                    <div class="w-full md:w-1/4 px-2 mb-3">
                        <label for="method" class="block text-sm font-medium text-gray-700 mb-1">Method</label>
                        <div class="relative">
                            <select id="method" name="method" class="block w-full rounded-md border-gray-300 bg-white pl-3 pr-10 py-2 text-base focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-sm appearance-none">
                                <option value="">All Methods</option>
                                <option value="GET">GET</option>
                                <option value="POST">POST</option>
                                <option value="PUT">PUT</option>
                                <option value="DELETE">DELETE</option>
                                <option value="HEAD">HEAD</option>
                            </select>
                            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                </svg>
                            </div>
                        </div>
                    </div>
                    <div class="w-full md:w-1/4 px-2 mb-3">
                        <label for="uri" class="block text-sm font-medium text-gray-700 mb-1">URI</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101" />
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 015.656 0l4 4a4 4 0 01-5.656 5.656l-1.102-1.101" />
                                </svg>
                            </div>
                            <input type="text" id="uri" name="uri" class="block w-full pl-10 pr-3 py-2 rounded-md border-gray-300 shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500" placeholder="e.g. /admin">
                        </div>
                    </div>
                    <div class="w-full md:w-1/4 px-2 mb-3">
                        <label for="start_date" class="block text-sm font-medium text-gray-700 mb-1">Start Date & Time</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                            </div>
                            <input type="datetime-local" id="start_date" name="start_date" step="1" class="block w-full pl-10 pr-3 py-2 rounded-md border-gray-300 shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        </div>
                    </div>
                    <div class="w-full md:w-1/4 px-2 mb-3">
                        <label for="end_date" class="block text-sm font-medium text-gray-700 mb-1">End Date & Time</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                            </div>
                            <input type="datetime-local" id="end_date" name="end_date" step="1" class="block w-full pl-10 pr-3 py-2 rounded-md border-gray-300 shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        </div>
                    </div>
                    <div class="w-full flex justify-end px-2">
                        <button type="button" id="clearFiltersBtn" class="px-4 py-2 bg-gray-500 hover:bg-gray-600 text-white rounded mr-2">
                            Clear Filters
                        </button>
                        <button type="submit" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded">
                            Apply Filters
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="flex flex-wrap mb-4">
    <div class="md:w-full">
        <div class="bg-white rounded-lg shadow">
            <div class="px-4 py-3 border-b flex justify-between items-center">
                <h5 class="text-lg font-medium mb-0">Security Events</h5>
                <span id="log-count" class="text-sm text-gray-600">
                    Showing <span id="shown-count">0</span> of <span id="total-count">0</span> events
                </span>
            </div>
            <div class="p-0">
                <div id="logs-loading" class="text-center py-4">
                    <div class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-blue-600 border-t-transparent" role="status">
                        <span class="sr-only">Loading...</span>
                    </div>
                    <p class="mt-2">Loading security logs...</p>
                </div>
                <div id="logs-empty" class="text-center py-4 hidden">
                    <i class="bi bi-shield-check text-4xl text-gray-500"></i>
                    <p class="mt-2">No security events found for the selected filters.</p>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full mb-0" id="logs-table">
                        <thead>
                            <tr>
                                <th class="px-4 py-2 text-left">Time</th>
                                <th class="px-4 py-2 text-left">Site</th>
                                <th class="px-4 py-2 text-left">Client IP</th>
                                <th class="px-4 py-2 text-left">Method</th>
                                <th class="px-4 py-2 text-left">URI</th>
                                <th class="px-4 py-2 text-left">Action</th>
                                <th class="px-4 py-2 text-left">Severity</th>
                                <th class="px-4 py-2 text-left">Status</th>
                                <th class="px-4 py-2 text-left">Details</th>
                            </tr>
                        </thead>
                        <tbody id="logs-tbody" class="divide-y">
                            <!-- Security logs will be loaded here via JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="px-4 py-3 border-t">
                <div class="flex justify-between">
                    <div>
                        <div class="relative">
                            <select id="page-size" class="rounded-md border-gray-300 shadow-sm bg-white pl-3 pr-10 py-2 text-base focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 appearance-none">
                                <option value="10">10 per page</option>
                                <option value="20" selected>20 per page</option>
                                <option value="50">50 per page</option>
                                <option value="100">100 per page</option>
                            </select>
                            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                </svg>
                            </div>
                        </div>
                    </div>
                    <div class="flex space-x-1" id="pagination-container">
                        <!-- Pagination will be loaded here -->
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- AI Summary Modal -->
<div id="summaryModal" class="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50 hidden overflow-y-auto py-4">
    <div class="bg-white rounded-xl shadow-2xl max-w-4xl w-full mx-4 overflow-hidden flex flex-col max-h-[90vh] border border-gray-200 animate-fadeIn"> 
        <div class="px-6 py-4 border-b flex justify-between items-center flex-shrink-0 bg-gradient-to-r from-gray-900 to-gray-800 text-white">
            <div class="flex items-center">
                <div class="bg-gradient-to-r from-green-500 to-green-400 p-2 rounded-full mr-3 shadow-lg">
                    <i class="fas fa-robot text-white text-xl"></i>
                </div>
                <div>
                    <h5 class="text-xl font-medium">AI Security Intelligence</h5>
                    <p class="text-xs text-gray-300 mt-1">Comprehensive threat analysis • <span id="reportDate"></span></p>
                </div>
            </div>
            <button id="closeSummaryModal" class="text-gray-300 hover:text-white p-1.5 rounded-full hover:bg-gray-700 transition-all duration-200">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>
        </div>
        <div class="px-6 py-5 overflow-y-auto bg-gray-50" style="max-height: calc(90vh - 140px);">
            <div id="summaryLoading" class="text-center py-12">
                <div class="w-28 h-28 mb-4 mx-auto relative">
                    <div class="absolute inset-0 flex items-center justify-center">
                        <i class="fas fa-shield-alt text-green-600 text-3xl animate-pulse"></i>
                    </div>
                    <div class="h-28 w-28 rounded-full border-4 border-green-500 border-opacity-30 border-t-green-500 animate-spin"></div>
                </div>
                <p class="mt-6 text-xl font-medium text-gray-800">Analyzing Security Events</p>
                <p class="text-sm text-gray-500 mt-2">AI is processing events and identifying potential threats</p>
                <div class="mt-6 w-full max-w-md mx-auto h-2.5 bg-gray-200 rounded-full overflow-hidden shadow-inner">
                    <div id="loadingProgressBar" class="h-full bg-gradient-to-r from-green-500 via-green-400 to-green-500 transition-all duration-1000 bg-[length:200%_100%] animate-gradientFlow" style="width: 0%"></div>
                </div>
                <p class="text-xs text-gray-400 mt-2">This typically takes 10-15 seconds</p>
            </div>
            <div id="summaryContent" class="hidden prose prose-lg max-w-none">
                <!-- Content will be rendered here by marked.js -->
            </div>
            <div id="summaryError" class="bg-red-50 border border-red-200 text-red-700 p-6 rounded-lg shadow-sm hidden">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <svg class="h-6 w-6 text-red-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                        </svg>
                    </div>
                    <div class="ml-3">
                        <p class="text-lg font-medium" id="summaryErrorTitle">Error</p>
                        <p class="text-sm mt-1" id="summaryErrorMessage">Failed to generate summary. Please try again later.</p>
                        <div class="mt-4">
                            <button id="retrySummary" class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-md shadow-sm transition duration-150 ease-in-out flex items-center">
                                <svg class="h-4 w-4 mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                                </svg>
                                Try Again
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="px-6 py-4 border-t bg-gray-100 flex justify-between items-center flex-shrink-0">

            <div class="flex space-x-3">
                <button id="downloadReport" class="px-4 py-2 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white rounded-md shadow-sm transition duration-150 ease-in-out hidden flex items-center">
                    <i class="fas fa-file-download mr-1.5"></i> Download Report
                </button>
                <button id="closeSummaryButton" class="px-4 py-2 bg-gray-500 hover:bg-gray-600 text-white rounded-md shadow-sm transition duration-150 ease-in-out">
                    Close
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/marked@4.3.0/marked.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Variables for pagination
    let currentPage = 1;
    let pageSize = 20;
    let timeRange = '24h';
    
    // Load sites for filter dropdown
    loadSites();
    
    // Load initial logs
    loadLogs();
    
    // Event listeners
    document.getElementById('logFilterForm').addEventListener('submit', function(e) {
        e.preventDefault();
        currentPage = 1;
        loadLogs();
    });
    
    document.getElementById('refreshBtn').addEventListener('click', function() {
        loadLogs();
    });
    
    document.getElementById('clearFiltersBtn').addEventListener('click', function() {
        document.getElementById('logFilterForm').reset();
        // Reset the date fields explicitly
        document.getElementById('start_date').value = '';
        document.getElementById('end_date').value = '';
        currentPage = 1;
        timeRange = '24h'; // Reset to default time range
        
        // Update the active button in time range selector
        document.querySelectorAll('#time-range-selector button').forEach(btn => {
            if (btn.dataset.range === timeRange) {
                btn.classList.add('active', 'bg-gray-100');
                btn.classList.remove('bg-white');
            } else {
                btn.classList.remove('active', 'bg-gray-100');
                btn.classList.add('bg-white');
            }
        });
        
        // Set default date range
        setDateRangeFromPreset(timeRange);
        
        loadLogs();
    });
    
    document.getElementById('page-size').addEventListener('change', function() {
        pageSize = parseInt(this.value);
        currentPage = 1;
        loadLogs();
    });
    
    // Time range selector
    document.getElementById('time-range-selector').addEventListener('click', function(e) {
        if (e.target.tagName === 'BUTTON') {
            // Update active button
            document.querySelectorAll('#time-range-selector button').forEach(btn => {
                btn.classList.remove('active', 'bg-gray-100');
                btn.classList.add('bg-white');
            });
            
            e.target.classList.add('active', 'bg-gray-100');
            e.target.classList.remove('bg-white');
            
            // Update time range and reload logs
            timeRange = e.target.dataset.range;
            
            // Set date inputs based on time range
            setDateRangeFromPreset(timeRange);
            
            currentPage = 1;
            loadLogs();
        }
    });

    // Configure marked.js options for security and rendering
    marked.setOptions({
        renderer: new marked.Renderer(),
        highlight: function(code, lang) {
            return code;
        },
        pedantic: false,
        gfm: true,
        breaks: true,
        sanitize: false,
        smartypants: false,
        xhtml: false
    });

    // Summarize logs button
    document.getElementById('summarizeLogsBtn').addEventListener('click', function() {
        fetchSummary();
    });

    // Close modal buttons
    document.getElementById('closeSummaryModal').addEventListener('click', function() {
        document.getElementById('summaryModal').classList.add('hidden');
    });

    document.getElementById('closeSummaryButton').addEventListener('click', function() {
        document.getElementById('summaryModal').classList.add('hidden');
    });

    // Download report button
    document.getElementById('downloadReport').addEventListener('click', function() {
        downloadSummaryReport();
    });

    // Retry button
    if (document.getElementById('retrySummary')) {
        document.getElementById('retrySummary').addEventListener('click', function() {
            fetchSummary();
        });
    }

    function fetchSummary() {
        // Get active filter values
        const formData = new FormData(document.getElementById('logFilterForm'));
        const params = new URLSearchParams();
        
        // Add relevant filter parameters
        if (formData.get('start_date')) {
            params.append('start_date', formData.get('start_date'));
        }
        
        if (formData.get('end_date')) {
            params.append('end_date', formData.get('end_date'));
        }
        
        // Set report date with proper formatting
        const now = new Date();
        const options = { 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        };
        document.getElementById('reportDate').textContent = now.toLocaleDateString(undefined, options);
        
        // Show the modal
        document.getElementById('summaryModal').classList.remove('hidden');
        
        // Show loading, hide content and error
        document.getElementById('summaryLoading').classList.remove('hidden');
        document.getElementById('summaryContent').classList.add('hidden');
        document.getElementById('summaryError').classList.add('hidden');
        document.getElementById('downloadReport').classList.add('hidden');
        
        // Animate loading progress bar
        const progressBar = document.getElementById('loadingProgressBar');
        progressBar.style.width = '0%';
        
        // Simulate progress animation
        let progress = 0;
        const progressInterval = setInterval(() => {
            progress += Math.random() * 2;
            if (progress > 95) {
                clearInterval(progressInterval);
                return;
            }
            progressBar.style.width = progress + '%';
        }, 300);
        
        // Set a timeout in case the API call takes too long
        const timeoutId = setTimeout(() => {
            clearInterval(progressInterval);
            document.getElementById('summaryLoading').classList.add('hidden');
            document.getElementById('summaryError').classList.remove('hidden');
            document.getElementById('summaryErrorTitle').textContent = "Request taking too long";
            document.getElementById('summaryErrorMessage').textContent = 
                "The AI service is taking longer than expected to respond. You can wait or try again later.";
        }, 35000); // 35 seconds local timeout as a fallback
        
        // Call the API to get summary
        api.get('/waf/logs/summary', { params: Object.fromEntries(params) })
            .then(response => {
                // Clear the timeout and progress interval
                clearTimeout(timeoutId);
                clearInterval(progressInterval);
                
                // Complete the progress bar
                progressBar.style.width = '100%';
                
                if (response.data && response.data.success && response.data.summary) {
                    // Render the summary as markdown
                    const renderedHtml = marked.parse(response.data.summary);
                    
                    // Apply custom styles to the HTML content
                    const styledHtml = applyCustomStylesToReport(renderedHtml);
                    
                    // Insert the HTML into the content div
                    document.getElementById('summaryContent').innerHTML = styledHtml;
                    
                    // Store original markdown for download
                    document.getElementById('summaryContent').dataset.markdown = response.data.summary;
                    
                    // Hide loading, show content after a brief delay to complete animation
                    setTimeout(() => {
                        document.getElementById('summaryLoading').classList.add('hidden');
                        document.getElementById('summaryContent').classList.remove('hidden');
                        document.getElementById('downloadReport').classList.remove('hidden');
                    }, 500);
                } else {
                    throw new Error('Invalid response format or empty summary');
                }
            })
            .catch(error => {
                // Clear the timeout and progress interval
                clearTimeout(timeoutId);
                clearInterval(progressInterval);
                
                // Hide loading, show error
                document.getElementById('summaryLoading').classList.add('hidden');
                document.getElementById('summaryError').classList.remove('hidden');
                
                // Update error message with details
                document.getElementById('summaryErrorTitle').textContent = "Summary Generation Failed";
                
                // Check for specific timeout error
                if (error.message && error.message.includes('timeout') || 
                    (error.response && error.response.data && error.response.data.message && 
                     error.response.data.message.includes('timeout'))) {
                    document.getElementById('summaryErrorMessage').textContent = 
                        "The AI service timed out. This usually happens when the service is under heavy load. Please try again in a few moments.";
                } else if (error.response && error.response.data && error.response.data.message) {
                    document.getElementById('summaryErrorMessage').textContent = error.response.data.message;
                } else {
                    document.getElementById('summaryErrorMessage').textContent = 
                        "Failed to generate summary. " + (error.message || "Please try again later.");
                }
            });
    }

    // Apply custom styles to the rendered HTML report
    function applyCustomStylesToReport(html) {
        // Add custom classes and styling to the HTML
        let styledHtml = html;
        
        // Add card container for the whole report
        styledHtml = `<div class="bg-white p-4 shadow-sm rounded-lg border border-gray-200 overflow-hidden">${styledHtml}</div>`;
        
        // Style section headers (look for h1, h2, h3 or markdown # style headers)
        styledHtml = styledHtml.replace(/<h1>(.*?)<\/h1>/g, 
            '<h1 class="text-2xl font-bold mt-6 mb-4 text-gray-800 border-b pb-2">$1</h1>');
        styledHtml = styledHtml.replace(/<h2>(.*?)<\/h2>/g, 
            '<h2 class="text-xl font-bold mt-5 mb-3 text-gray-800">$1</h2>');
        styledHtml = styledHtml.replace(/<h3>(.*?)<\/h3>/g, 
            '<h3 class="text-lg font-bold mt-4 mb-2 text-gray-800">$1</h3>');
        
        // Style specific sections
        styledHtml = styledHtml.replace(/<h[1-3]>(EXECUTIVE SUMMARY|Executive Summary)(.*)(<\/h[1-3]>)/g, 
            '<div class="bg-gradient-to-r from-blue-600 to-blue-800 text-white px-6 py-4 flex items-center">' +
            '<div class="rounded-full bg-white p-2 mr-3"><i class="fas fa-chart-line text-blue-700 text-xl"></i></div>' +
            '<div><h2 class="font-bold text-xl m-0">EXECUTIVE SUMMARY$2</h2>' +
            '<p class="text-blue-100 text-sm mt-1">Overall security assessment</p></div></div>' +
            '<div class="px-6 py-4">');
        
        styledHtml = styledHtml.replace(/<h[1-3]>(KEY FINDINGS|Key Findings)(.*)(<\/h[1-3]>)/g, 
            '</div><div class="bg-gradient-to-r from-green-600 to-green-700 text-white px-6 py-4 flex items-center border-t border-gray-200">' +
            '<div class="rounded-full bg-white p-2 mr-3"><i class="fas fa-key text-green-700 text-xl"></i></div>' +
            '<div><h2 class="font-bold text-xl m-0">KEY FINDINGS$2</h2>' +
            '<p class="text-green-100 text-sm mt-1">Most important observations</p></div></div>' +
            '<div class="px-6 py-4">');
        
        styledHtml = styledHtml.replace(/<h[1-3]>(CRITICAL ISSUES|Critical Issues|CRITICAL VULNERABILITIES|Critical Vulnerabilities)(.*)(<\/h[1-3]>)/g, 
            '</div><div class="bg-gradient-to-r from-red-600 to-red-700 text-white px-6 py-4 flex items-center border-t border-gray-200">' +
            '<div class="rounded-full bg-white p-2 mr-3"><i class="fas fa-exclamation-triangle text-red-700 text-xl"></i></div>' +
            '<div><h2 class="font-bold text-xl m-0">CRITICAL ISSUES$2</h2>' +
            '<p class="text-red-100 text-sm mt-1">Security vulnerabilities requiring attention</p></div></div>' +
            '<div class="px-6 py-4">');
        
        styledHtml = styledHtml.replace(/<h[1-3]>(RECOMMENDATIONS|Recommendations)(.*)(<\/h[1-3]>)/g, 
            '</div><div class="bg-gradient-to-r from-amber-500 to-amber-600 text-white px-6 py-4 flex items-center border-t border-gray-200">' +
            '<div class="rounded-full bg-white p-2 mr-3"><i class="fas fa-lightbulb text-amber-500 text-xl"></i></div>' +
            '<div><h2 class="font-bold text-xl m-0">RECOMMENDATIONS$2</h2>' +
            '<p class="text-amber-100 text-sm mt-1">Actions to improve security posture</p></div></div>' +
            '<div class="px-6 py-4">');
            
        // Close the last section div
        styledHtml = styledHtml + '</div>';
        
        // Style lists with better bullets and spacing
        styledHtml = styledHtml.replace(/<ul>/g, '<ul class="list-disc ml-6 mb-4 text-gray-700 space-y-2">');
        styledHtml = styledHtml.replace(/<ol>/g, '<ol class="list-decimal ml-6 mb-4 text-gray-700 space-y-2">');
        
        // Style paragraphs
        styledHtml = styledHtml.replace(/<p>/g, '<p class="mb-4 text-gray-700">');
        
        // Style inline code and pre blocks
        styledHtml = styledHtml.replace(/<code>/g, '<code class="bg-gray-100 text-red-600 px-1 py-0.5 rounded">');
        styledHtml = styledHtml.replace(/<pre>/g, '<pre class="bg-gray-100 p-4 rounded-md overflow-x-auto mb-4">');
        
        // Create threat level badges
        styledHtml = styledHtml.replace(/\b(Critical|High|Medium|Low)\b threat level/gi, 
            (match) => {
                const level = match.split(' ')[0].toLowerCase();
                const color = level === 'critical' ? 'red-600' : 
                            level === 'high' ? 'orange-600' : 
                            level === 'medium' ? 'amber-500' : 'blue-500';
                const bgColor = level === 'critical' ? 'red-100' : 
                            level === 'high' ? 'orange-100' : 
                            level === 'medium' ? 'amber-100' : 'blue-100';
                return `<span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-${bgColor} text-${color} border border-${color}">
                          <span class="mr-1.5 h-2.5 w-2.5 rounded-full bg-${color}"></span>${match}
                        </span>`;
            });
            
        // Highlight specific security terms
        styledHtml = styledHtml.replace(/\b(Critical|High|Medium|Low)\b/gi, 
            (match) => {
                if (match.toLowerCase() === 'critical') 
                    return `<span class="font-semibold text-red-600">${match}</span>`;
                if (match.toLowerCase() === 'high')
                    return `<span class="font-semibold text-orange-600">${match}</span>`;
                if (match.toLowerCase() === 'medium')
                    return `<span class="font-semibold text-amber-600">${match}</span>`;
                if (match.toLowerCase() === 'low')
                    return `<span class="font-semibold text-blue-600">${match}</span>`;
                return match;
            });
        
        // Highlight attack types
        styledHtml = styledHtml.replace(/\b(SQL Injection|XSS|CSRF|RCE|CVE-\d+-\d+|Remote Code Execution|Command Injection|Path Traversal|Brute Force)\b/gi, 
            '<span class="inline-flex items-center px-2 py-1 rounded-md text-sm font-semibold bg-red-50 text-red-700 border border-red-200">$1</span>');
        
        // Style tables
        styledHtml = styledHtml.replace(/<table>/g, 
            '<table class="min-w-full divide-y divide-gray-300 border border-gray-200 rounded-md overflow-hidden">');
        styledHtml = styledHtml.replace(/<thead>/g, 
            '<thead class="bg-gray-50">');
        styledHtml = styledHtml.replace(/<th>/g, 
            '<th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">');
        styledHtml = styledHtml.replace(/<tbody>/g, 
            '<tbody class="divide-y divide-gray-200 bg-white">');
        styledHtml = styledHtml.replace(/<td>/g, 
            '<td class="px-4 py-3 text-sm text-gray-600">');
        
        return styledHtml;
    }

    // Download summary as PDF or markdown
    function downloadSummaryReport() {
        const summaryContent = document.getElementById('summaryContent');
        const markdownContent = summaryContent.dataset.markdown;
        
        if (!markdownContent) return;
        
        // Create a blob with the markdown content
        const blob = new Blob([markdownContent], { type: 'text/markdown' });
        
        // Create download link
        const a = document.createElement('a');
        a.download = `SeproWAF_Security_Report_${new Date().toISOString().slice(0, 10)}.md`;
        a.href = window.URL.createObjectURL(blob);
        a.style.display = 'none';
        
        document.body.appendChild(a);
        a.click();
        
        // Cleanup
        window.URL.revokeObjectURL(a.href);
        document.body.removeChild(a);
    }

    // Functions
    function formatDatetime(date) {
        // Format date for datetime-local input (YYYY-MM-DDThh:mm:ss)
        // This formats the date in the local timezone, which is what datetime-local expects
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        const seconds = String(date.getSeconds()).padStart(2, '0');
        
        return `${year}-${month}-${day}T${hours}:${minutes}:${seconds}`;
    }

    function setDateRangeFromPreset(range) {
        const now = new Date();
        const startDateInput = document.getElementById('start_date');
        const endDateInput = document.getElementById('end_date');
        
        // Clear existing values
        startDateInput.value = '';
        endDateInput.value = '';
        
        // Set end date to now with time component
        const endDate = formatDatetime(now);
        endDateInput.value = endDate;
        
        // Set start date based on range
        let startDate;
        switch(range) {
            case '24h':
                const yesterday = new Date(now);
                yesterday.setHours(now.getHours() - 24);
                startDate = formatDatetime(yesterday);
                break;
            case '7d':
                const sevenDaysAgo = new Date(now);
                sevenDaysAgo.setDate(now.getDate() - 7);
                startDate = formatDatetime(sevenDaysAgo);
                break;
            case '30d':
                const thirtyDaysAgo = new Date(now);
                thirtyDaysAgo.setDate(now.getDate() - 30);
                startDate = formatDatetime(thirtyDaysAgo);
                break;
        }
        
        startDateInput.value = startDate;
    }
    
    async function loadSites() {
        try {
            const response = await api.get('/sites');
            const siteSelect = document.getElementById('site_id');
            
            // Get site_id from URL query parameters if present
            const urlParams = new URLSearchParams(window.location.search);
            const siteIdParam = urlParams.get('site_id');
            
            // Add site options
            response.data.forEach(site => {
                const option = document.createElement('option');
                option.value = site.ID;
                option.textContent = site.Name;
                
                // Set selected if matches URL parameter
                if (siteIdParam && siteIdParam == site.ID) {
                    option.selected = true;
                }
                
                siteSelect.appendChild(option);
            });
            
            // If we had a site_id in URL, trigger a filter
            if (siteIdParam) {
                loadLogs();
            }
        } catch (error) {
            console.error('Error loading sites:', error);
            showToast('Failed to load sites', 'danger');
        }
    }
    
    async function loadLogs() {
        const formData = new FormData(document.getElementById('logFilterForm'));
        const params = new URLSearchParams();
        
        // Add form data to params with proper handling of datetime inputs
        for (const [key, value] of formData.entries()) {
            if (value) {
                // For datetime-local inputs, we need to handle the date conversion properly
                if (key === 'start_date' || key === 'end_date') {
                    try {
                        const dateObj = new Date(value);
                        if (!isNaN(dateObj.getTime())) {
                            // Format the date as if it's in +03:00 without altering time
                            const pad = (num) => String(num).padStart(2, '0');
                            const year = dateObj.getFullYear();
                            const month = pad(dateObj.getMonth() + 1);
                            const day = pad(dateObj.getDate());
                            const hours = pad(dateObj.getHours());
                            const minutes = pad(dateObj.getMinutes());
                            const seconds = pad(dateObj.getSeconds());

                            // Just append +03:00 without offsetting the date
                            const formatted = `${year}-${month}-${day}T${hours}:${minutes}:${seconds}+03:00`;

                            params.append(key, formatted);
                        } else {
                            console.warn(`Invalid date for ${key}: ${value}`);
                        }
                    } catch (e) {
                        console.error(`Error parsing date for ${key}: ${e.message}`);
                    }
                } else {
                    params.append(key, value);
                }
            }
        }
        
        // Add pagination
        params.append('page', currentPage);
        params.append('page_size', pageSize);
                
        // Show loading
        document.getElementById('logs-loading').classList.remove('hidden');
        document.getElementById('logs-table').classList.add('hidden');
        document.getElementById('logs-empty').classList.add('hidden');
        
        try {
            const response = await api.get(`/waf/logs?${params.toString()}`);
            
            // Hide loading
            document.getElementById('logs-loading').classList.add('hidden');
            
            // Handle nested response structure
            const responseData = response.data;
            
            if (!responseData.data || responseData.data.length === 0) {
                document.getElementById('logs-empty').classList.remove('hidden');
                document.getElementById('logs-table').classList.add('hidden');
                document.getElementById('shown-count').textContent = '0';
                document.getElementById('total-count').textContent = '0';
                document.getElementById('pagination-container').innerHTML = '';
                return;
            }
            
            // Render logs with the correct data array
            renderLogs(responseData.data);
            
            // Update counts using the nested structure
            document.getElementById('shown-count').textContent = responseData.data.length;
            document.getElementById('total-count').textContent = responseData.pagination.total;
            
            // Render pagination with the correct pagination object
            renderPagination(responseData.pagination.page, responseData.pagination.total_pages);
            
            // Show table
            document.getElementById('logs-table').classList.remove('hidden');
        } catch (error) {
            console.error('Error loading logs:', error);
            showToast('Failed to load security logs', 'danger');
            document.getElementById('logs-loading').classList.add('hidden');
            document.getElementById('logs-empty').classList.remove('hidden');
        }
    }
    
    function renderLogs(logs) {
        const tbody = document.getElementById('logs-tbody');
        tbody.innerHTML = '';
        
        if (!Array.isArray(logs)) {
            console.error('Expected logs to be an array, but got:', logs);
            return;
        }
        
        logs.forEach(log => {
            const row = document.createElement('tr');
            row.className = 'hover:bg-gray-50';
            
            // Format date
            const date = new Date(log.CreatedAt);
            const formattedDate = new Intl.DateTimeFormat('default', {
                year: 'numeric',
                month: 'short',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            }).format(date);
            
            // Determine action color
            let actionClass;
            switch (log.Action) {
                case 'blocked':
                case 'blocked_response':
                    actionClass = 'bg-red-500';
                    break;
                case 'allowed':
                    actionClass = 'bg-green-500';
                    break;
                default:
                    actionClass = 'bg-gray-500';
            }
            
            // Determine severity color
            let severityClass;
            switch (log.Severity) {
                case 'critical':
                    severityClass = 'bg-red-500';
                    break;
                case 'high':
                    severityClass = 'bg-orange-500';
                    break;
                case 'medium':
                    severityClass = 'bg-yellow-500';
                    break;
                case 'low':
                    severityClass = 'bg-blue-500';
                    break;
                default:
                    severityClass = 'bg-gray-500';
            }
            
            // Build status display
            let statusDisplay = log.StatusCode;
            if (log.BlockStatusCode) {
                statusDisplay += ` → ${log.BlockStatusCode}`;
            }
            
            // Truncate URI if too long
            const uri = log.URI.length > 30 ? log.URI.substring(0, 27) + '...' : log.URI;
            
            row.innerHTML = `
                <td class="px-4 py-2">${formattedDate}</td>
                <td class="px-4 py-2">${log.Domain}</td>
                <td class="px-4 py-2">${log.ClientIP}</td>
                <td class="px-4 py-2">${log.Method}</td>
                <td class="px-4 py-2" title="${log.URI}">${uri}</td>
                <td class="px-4 py-2">
                    <span class="px-2 py-1 text-xs font-medium rounded-full ${actionClass} text-white">
                        ${log.Action}
                    </span>
                </td>
                <td class="px-4 py-2">
                    ${log.Severity ? `
                    <span class="px-2 py-1 text-xs font-medium rounded-full ${severityClass} text-white">
                        ${log.Severity}
                    </span>` : 'N/A'}
                </td>
                <td class="px-4 py-2">${statusDisplay}</td>
                <td class="px-4 py-2">
                    <a href="/waf/logs/${log.ID}" class="px-2 py-1 text-sm border border-blue-600 text-blue-600 hover:bg-blue-600 hover:text-white rounded">
                        <i class="bi bi-search"></i> View
                    </a>
                </td>
            `;
            
            tbody.appendChild(row);
        });
    }
    
    function renderPagination(currentPage, totalPages) {
        const container = document.getElementById('pagination-container');
        container.innerHTML = '';
        
        if (totalPages <= 1) {
            return;
        }
        
        // Previous button
        if (currentPage > 1) {
            addPaginationButton(container, currentPage - 1, '&laquo; Prev');
        }
        
        // Page numbers
        const startPage = Math.max(1, currentPage - 2);
        const endPage = Math.min(totalPages, currentPage + 2);
        
        if (startPage > 1) {
            addPaginationButton(container, 1, '1');
            if (startPage > 2) {
                addPaginationEllipsis(container);
            }
        }
        
        for (let i = startPage; i <= endPage; i++) {
            addPaginationButton(container, i, i.toString(), i === currentPage);
        }
        
        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                addPaginationEllipsis(container);
            }
            addPaginationButton(container, totalPages, totalPages.toString());
        }
        
        // Next button
        if (currentPage < totalPages) {
            addPaginationButton(container, currentPage + 1, 'Next &raquo;');
        }
    }
    
    function addPaginationButton(container, page, label, isActive = false) {
        const button = document.createElement('button');
        button.innerHTML = label;
        button.className = isActive 
            ? 'px-3 py-1 text-sm font-medium border border-blue-600 bg-blue-600 text-white rounded'
            : 'px-3 py-1 text-sm font-medium border border-gray-300 text-gray-700 hover:bg-gray-100 rounded';
        
        button.addEventListener('click', function() {
            currentPage = page;
            loadLogs();
        });
        
        container.appendChild(button);
    }
    
    function addPaginationEllipsis(container) {
        const span = document.createElement('span');
        span.innerHTML = '...';
        span.className = 'px-3 py-1 text-sm font-medium text-gray-700';
        container.appendChild(span);
    }
    
    // Initialize with default time range
    setDateRangeFromPreset(timeRange);
});</script>

<style>
/* Add styles for severity and action badges */
.severity-critical { background-color: #ef4444 !important; }
.severity-high { background-color: #f97316 !important; }
.severity-medium { background-color: #eab308 !important; }
.severity-low { background-color: #3b82f6 !important; }

.action-blocked { background-color: #ef4444 !important; }
.action-allowed { background-color: #22c55e !important; }
.action-blocked_response { background-color: #ef4444 !important; }

/* Make sure table is responsive */
.overflow-x-auto {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
}
</style>