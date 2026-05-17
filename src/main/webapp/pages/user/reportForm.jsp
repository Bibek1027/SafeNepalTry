<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.safenepal.location.model.Location" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Report — SafeNepal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f5f7fb; min-height: 100vh; display: flex; flex-direction: column; color: #1e293b; }
        .main-wrapper { flex: 1 0 auto; }

        .page-banner {
            background: linear-gradient(135deg, #0d1440 0%, #1a237e 100%);
            padding: 48px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .page-banner::before {
            content: '';
            position: absolute;
            top: -40%; right: -15%;
            width: 350px; height: 350px;
            background: radial-gradient(circle, rgba(229,57,53,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }
        .page-banner h1 { font-size: 28px; font-weight: 900; color: #fff; position: relative; z-index: 1; }
        .page-banner p  { font-size: 14px; color: rgba(255,255,255,0.55); margin-top: 8px; position: relative; z-index: 1; }

        .form-container { max-width: 640px; margin: -28px auto 48px; padding: 0 24px; position: relative; z-index: 10; }
        .form-card { background: #fff; border-radius: 24px; padding: 40px; box-shadow: 0 8px 40px rgba(0,0,0,0.06); border: 1px solid rgba(0,0,0,0.04); }

        .alert { padding: 12px 16px; border-radius: 12px; font-size: 13px; font-weight: 500; margin-bottom: 24px; background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; animation: fadeIn 0.3s ease; }
        .alert-success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }

        .form-group { margin-bottom: 22px; }
        .form-group label { display: block; font-size: 13px; font-weight: 600; color: #475569; margin-bottom: 8px; letter-spacing: 0.2px; }
        .form-group label .required { color: #e53935; }
        .form-group select, .form-group input[type="text"], .form-group textarea {
            width: 100%; padding: 13px 16px; border: 1.5px solid #e2e8f0; border-radius: 12px;
            font-size: 14px; font-family: 'Inter', sans-serif; color: #1e293b; background: #f8fafc;
            transition: border-color 0.2s, box-shadow 0.2s, background 0.2s; outline: none; -webkit-appearance: none;
        }
        .form-group select {
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%2394a3b8' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat; background-position: right 16px center; padding-right: 40px;
        }
        .form-group textarea { resize: vertical; min-height: 110px; line-height: 1.6; }
        .form-group select:focus, .form-group input[type="text"]:focus, .form-group textarea:focus {
            border-color: #1a237e; box-shadow: 0 0 0 3px rgba(26,35,126,0.08); background: #fff;
        }

        /* Disaster Type Selector */
        .disaster-types { display: grid; grid-template-columns: repeat(auto-fit, minmax(100px, 1fr)); gap: 10px; }
        .disaster-type-option { position: relative; }
        .disaster-type-option input { display: none; }
        .disaster-type-option label {
            display: flex; flex-direction: column; align-items: center; gap: 6px;
            padding: 16px 8px; border: 1.5px solid #e2e8f0; border-radius: 14px; cursor: pointer;
            transition: all 0.2s; background: #f8fafc; font-size: 12px; font-weight: 600; color: #64748b; text-align: center;
        }
        .disaster-type-option label .icon { font-size: 24px; }
        .disaster-type-option input:checked + label { border-color: #1a237e; background: #e8eaf6; color: #1a237e; box-shadow: 0 2px 8px rgba(26,35,126,0.12); }

        /* Image Upload Area */
        .upload-area {
            border: 2px dashed #cbd5e1;
            border-radius: 14px;
            padding: 24px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            background: #f8fafc;
            position: relative;
        }
        .upload-area:hover, .upload-area.drag-over { border-color: #1a237e; background: #f0f4ff; }
        .upload-area input[type="file"] { display: none; }
        .upload-area .upload-icon { font-size: 32px; margin-bottom: 8px; }
        .upload-area .upload-label { font-size: 14px; font-weight: 600; color: #475569; }
        .upload-area .upload-sub   { font-size: 12px; color: #94a3b8; margin-top: 4px; }
        .upload-btn {
            display: inline-block;
            margin-top: 12px;
            padding: 8px 20px;
            background: #e8eaf6;
            color: #1a237e;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
        }
        .upload-btn:hover { background: #c5cae9; }

        /* Image Preview Strip */
        .preview-strip {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 14px;
        }
        .preview-thumb {
            position: relative;
            width: 80px;
            height: 80px;
        }
        .preview-thumb img {
            width: 80px;
            height: 80px;
            border-radius: 10px;
            object-fit: cover;
            border: 2px solid #e2e8f0;
        }
        .preview-thumb .remove-thumb {
            position: absolute;
            top: -6px;
            right: -6px;
            width: 20px;
            height: 20px;
            background: #e53935;
            color: #fff;
            border: none;
            border-radius: 50%;
            font-size: 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 900;
            line-height: 1;
        }
        .file-hint { font-size: 11px; color: #94a3b8; margin-top: 8px; }
        .file-hint .ok   { color: #2e7d32; font-weight: 600; }
        .file-hint .warn { color: #ef6c00; font-weight: 600; }

        .btn-submit {
            width: 100%; padding: 15px;
            background: linear-gradient(135deg, #e53935, #c62828);
            color: #fff; border: none; border-radius: 12px;
            font-size: 15px; font-weight: 700; font-family: 'Inter', sans-serif;
            cursor: pointer; transition: all 0.25s ease; margin-top: 8px;
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(229,57,53,0.3); }

        .back-link { display: block; text-align: center; margin-top: 20px; font-size: 14px; color: #64748b; }
        .back-link a { color: #1a237e; font-weight: 700; text-decoration: none; }
        .back-link a:hover { color: #e53935; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(-4px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
<div class="main-wrapper">
    <jsp:include page="../../components/app-header.jsp" />

    <div class="page-banner">
        <h1>Report a Disaster</h1>
        <p>Help your community by providing accurate information about emergencies</p>
    </div>

    <div class="form-container">
        <div class="form-card">
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert">Error: <%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">Success: <%= request.getAttribute("success") %></div>
            <% } %>

            <%-- IMPORTANT: enctype="multipart/form-data" is required for file uploads --%>
            <form action="${pageContext.request.contextPath}/user/report" method="post" enctype="multipart/form-data" id="reportForm">

                <!-- Disaster Type -->
                <div class="form-group">
                    <label>Disaster Type <span class="required">*</span></label>
                    <div class="disaster-types">
                        <div class="disaster-type-option">
                            <input type="radio" id="flood" name="disasterType" value="Flood" required>
                            <label for="flood">Flood</label>
                        </div>
                        <div class="disaster-type-option">
                            <input type="radio" id="earthquake" name="disasterType" value="Earthquake">
                            <label for="earthquake">Earthquake</label>
                        </div>
                        <div class="disaster-type-option">
                            <input type="radio" id="landslide" name="disasterType" value="Landslide">
                            <label for="landslide">Landslide</label>
                        </div>
                        <div class="disaster-type-option">
                            <input type="radio" id="fire" name="disasterType" value="Road Blockage">
                            <label for="fire">Road Block</label>
                        </div>
                        <div class="disaster-type-option">
                            <input type="radio" id="other" name="disasterType" value="Other">
                            <label for="other">Other</label>
                        </div>
                    </div>
                </div>

                <!-- Location Selection -->
                <div class="form-group">
                    <label for="locationId">Location <span class="required">*</span></label>
                    <select id="locationId" name="locationId" required>
                        <option value="" disabled selected>Select your location...</option>
                        <%
                            List<Location> locations = (List<Location>) request.getAttribute("locations");
                            if (locations != null) {
                                for (Location loc : locations) {
                        %>
                            <option value="<%= loc.getLocationId() %>"><%= loc.getLocationName() %> (<%= loc.getDistrict() %>)</option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>

                <!-- Description -->
                <div class="form-group">
                    <label for="description">Description <span class="required">*</span></label>
                    <textarea id="description" name="description"
                              placeholder="Describe the situation — what's happening, how severe, any immediate dangers or needs..." required></textarea>
                </div>

                <!-- Image/Video Upload -->
                <div class="form-group">
                    <label>Photos & Videos <span style="color:#94a3b8; font-weight:500;">(Optional — max 3 files)</span></label>
                    <div class="upload-area" id="uploadArea" onclick="document.getElementById('imageInput').click()"
                         ondragover="handleDragOver(event)" ondragleave="handleDragLeave(event)" ondrop="handleDrop(event)">
                        <div class="upload-icon">I</div>
                        <div class="upload-label">Drag & drop images or videos here</div>
                        <div class="upload-sub">or click to browse</div>
                        <span class="upload-btn">Choose Files</span>
                        <%-- 'multiple' allows picking several files at once --%>
                        <input type="file" id="imageInput" name="images" accept=".jpg,.jpeg,.png,.mp4,.mov,.avi" multiple
                               onchange="handleFileSelect(this.files)">
                    </div>
                    <div class="preview-strip" id="previewStrip"></div>
                    <p class="file-hint">
                        Accepted: <span class="ok">JPG, JPEG, PNG, MP4, MOV, AVI</span> &nbsp;|&nbsp;
                        Max size: <span class="ok">50 MB</span> per file &nbsp;|&nbsp;
                        Max: <span class="ok">3 files</span>
                    </p>
                    <p class="file-hint warn" id="fileError" style="display:none;"></p>
                </div>

                <button type="submit" class="btn-submit" id="submitBtn">Submit Report</button>
            </form>

            <p class="back-link"><a href="${pageContext.request.contextPath}/user/dashboard">← Back to My Reports</a></p>
        </div>
    </div>
</div>
<jsp:include page="../../components/footer.jsp" />

<script>
    // Stores the DataTransfer object to allow removing individual files
    let selectedFiles = [];
    const MAX_FILES   = 3;
    const MAX_SIZE_MB = 50;
    const ALLOWED_EXT = ['jpg','jpeg','png','mp4','mov','avi'];

    function handleFileSelect(files) {
        const err = document.getElementById('fileError');
        err.style.display = 'none';
        err.textContent = '';

        for (let f of files) {
            if (selectedFiles.length >= MAX_FILES) {
                showErr('Maximum 3 images allowed.');
                break;
            }
            const ext = f.name.split('.').pop().toLowerCase();
            if (!ALLOWED_EXT.includes(ext)) { showErr('Only JPG and PNG images are allowed.'); continue; }
            if (f.size > MAX_SIZE_MB * 1024 * 1024) { showErr(f.name + ' exceeds 5 MB limit.'); continue; }
            selectedFiles.push(f);
        }
        renderPreviews();
        syncInput();
    }

    function renderPreviews() {
        const strip = document.getElementById('previewStrip');
        strip.innerHTML = '';
        selectedFiles.forEach((f, idx) => {
            const reader = new FileReader();
            reader.onload = e => {
                const div = document.createElement('div');
                div.className = 'preview-thumb';
                div.innerHTML = '<img src="' + e.target.result + '" alt="Preview">' +
                    '<button type="button" class="remove-thumb" onclick="removeFile(' + idx + ')">✕</button>';
                strip.appendChild(div);
            };
            reader.readAsDataURL(f);
        });
    }

    function removeFile(idx) {
        selectedFiles.splice(idx, 1);
        renderPreviews();
        syncInput();
    }

    // Sync the actual <input type="file"> with our selectedFiles array using DataTransfer
    function syncInput() {
        const input = document.getElementById('imageInput');
        const dt    = new DataTransfer();
        selectedFiles.forEach(f => dt.items.add(f));
        input.files = dt.files;
    }

    function showErr(msg) {
        const err = document.getElementById('fileError');
        err.textContent = msg;
        err.style.display = 'block';
    }

    // Drag & drop handlers
    function handleDragOver(e)  { e.preventDefault(); document.getElementById('uploadArea').classList.add('drag-over'); }
    function handleDragLeave(e) { document.getElementById('uploadArea').classList.remove('drag-over'); }
    function handleDrop(e) {
        e.preventDefault();
        document.getElementById('uploadArea').classList.remove('drag-over');
        handleFileSelect(e.dataTransfer.files);
    }
</script>
</body>
</html>
