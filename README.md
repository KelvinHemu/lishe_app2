## 🔐 HTTPS Setup & Testing

### Pre-configured HTTPS
The app automatically runs with HTTPS at:  
`https://localhost:8443`  
*(No setup needed - certificate is pre-configured)*

### Postman Testing
 **Import the certificate**:
   - Locate `lisheapp-cert.cer` in `src/main/resources/`
   - In Postman:
     1. Settings → Certificates → "Add Certificate"
     2. Enter:
        - Host: `localhost`
        - Port: `8443`
        - CRT file: Select `lisheapp-cert.cer`
     3. Save

### Access Endpoints
- Use base URL: `https://localhost:8443`
- All routes will now work without SSL errors
