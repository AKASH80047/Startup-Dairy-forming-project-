const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
require('dotenv').config();

const locationController = require('./controllers/location_controller');

const app = express();
const PORT = process.env.PORT || 3000;

// Setup database connection pool with fallback tracking
let dbPool = null;
try {
  if (process.env.DATABASE_URL) {
    dbPool = new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
    });
    console.log('Database pool initialized for location services');
  }
} catch (err) {
  console.warn('Database configuration failed, falling back to mock mode:', err.message);
}

// Share pool reference on request object
app.use((req, res, next) => {
  req.db = dbPool;
  next();
});

// Configure middleware
app.use(cors());
app.use(express.json());

// Administrative Location Selector Routes
app.get('/api/locations/states', locationController.getStates);
app.get('/api/locations/states/:stateCode/districts', locationController.getDistrictsByState);
app.get('/api/locations/districts/:districtCode/subdistricts', locationController.getSubDistrictsByDistrict);
app.get('/api/locations/subdistricts/:subDistrictCode/villages', locationController.getVillagesBySubDistrict);
app.get('/api/locations/villages/search', locationController.searchVillages);
app.get('/api/locations/villages/:villageCode', locationController.getVillageDetails);

// Health check endpoint
app.get('/health', async (req, res) => {
  let dbStatus = 'disconnected';
  if (req.db) {
    try {
      await req.db.query('SELECT 1');
      dbStatus = 'healthy';
    } catch (_) {
      dbStatus = 'unhealthy';
    }
  }
  res.json({
    status: 'online',
    database: dbStatus,
    mode: req.db ? 'live' : 'mock-fallback'
  });
});

// Boot server
app.listen(PORT, () => {
  console.log(`Pandey Dairy location server running on http://localhost:${PORT}`);
});
