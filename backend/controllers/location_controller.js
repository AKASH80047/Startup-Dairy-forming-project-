// Location Service Controller

// Mock data memory store for fallback when database is unconfigured or unreachable
const mockStates = [
  { code: '8', nameEn: 'Rajasthan', nameHi: 'राजस्थान', type: 'STATE' },
  { code: '9', nameEn: 'Uttar Pradesh', nameHi: 'उत्तर प्रदेश', type: 'STATE' },
  { code: '7', nameEn: 'Delhi', nameHi: 'दिल्ली', type: 'UT' }
];

const mockDistricts = [
  // Rajasthan
  { code: 'RJ_01', stateCode: '8', nameEn: 'Jaipur', nameHi: 'जयपुर' },
  { code: 'RJ_02', stateCode: '8', nameEn: 'Bikaner', nameHi: 'बीकानेर' },
  { code: 'RJ_03', stateCode: '8', nameEn: 'Jodhpur', nameHi: 'जोधपुर' },
  // Uttar Pradesh
  { code: 'UP_01', stateCode: '9', nameEn: 'Siddharthnagar', nameHi: 'सिद्धार्थनगर' },
  { code: 'UP_02', stateCode: '9', nameEn: 'Ayodhya', nameHi: 'अयोध्या' },
  { code: 'UP_03', stateCode: '9', nameEn: 'Gorakhpur', nameHi: 'गोरखपुर' },
  // Delhi
  { code: 'DL_01', stateCode: '7', nameEn: 'New Delhi', nameHi: 'नई दिल्ली' }
];

const mockSubDistricts = [
  // Jaipur, RJ
  { code: 'JP_TEH_01', districtCode: 'RJ_01', nameEn: 'Jaipur Tehsil', nameHi: 'जयपुर तहसील' },
  { code: 'JP_TEH_02', districtCode: 'RJ_01', nameEn: 'Sanganer', nameHi: 'सांगानेर' },
  // Siddharthnagar, UP
  { code: 'SN_TEH_01', districtCode: 'UP_01', nameEn: 'Naugarh', nameHi: 'नौगढ़' },
  { code: 'SN_TEH_02', districtCode: 'UP_01', nameEn: 'Bansi', nameHi: 'बांसी' },
  { code: 'SN_TEH_03', districtCode: 'UP_01', nameEn: 'Itwa', nameHi: 'इटवा' },
  { code: 'SN_TEH_04', districtCode: 'UP_01', nameEn: 'Domariaganj', nameHi: 'डुमरियागंज' },
  { code: 'SN_TEH_05', districtCode: 'UP_01', nameEn: 'Shohratgarh', nameHi: 'शोहरतगढ़' }
];

const mockVillages = [
  // Jaipur, Sanganer
  { code: 'JP_VILL_01', subDistrictCode: 'JP_TEH_02', nameEn: 'Gopalpura', nameHi: 'गोपालपुरा' },
  { code: 'JP_VILL_02', subDistrictCode: 'JP_TEH_02', nameEn: 'Sodala', nameHi: 'सोडाला' },
  { code: 'JP_VILL_03', subDistrictCode: 'JP_TEH_02', nameEn: 'Vaishali Nagar', nameHi: 'वैशाली नगर' },
  { code: 'JP_VILL_04', subDistrictCode: 'JP_TEH_02', nameEn: 'Mansarovar', nameHi: 'मानसरोवर' },

  // Siddharthnagar, Naugarh
  { code: 'SN_VILL_01', subDistrictCode: 'SN_TEH_01', nameEn: 'Naugarh', nameHi: 'नौगढ़' },
  { code: 'SN_VILL_02', subDistrictCode: 'SN_TEH_01', nameEn: 'Birdpur No. 1', nameHi: 'बर्डपुर नंबर 1' },
  { code: 'SN_VILL_03', subDistrictCode: 'SN_TEH_01', nameEn: 'Jogia', nameHi: 'जोगिया' },
  { code: 'SN_VILL_04', subDistrictCode: 'SN_TEH_01', nameEn: 'Kakrahi', nameHi: 'ककराही' },
  { code: 'SN_VILL_05', subDistrictCode: 'SN_TEH_01', nameEn: 'Bariji', nameHi: 'बारीजी' },
  { code: 'SN_VILL_06', subDistrictCode: 'SN_TEH_01', nameEn: 'Nankar', nameHi: 'नानकार' },
  { code: 'SN_VILL_07', subDistrictCode: 'SN_TEH_01', nameEn: 'Madhubani', nameHi: 'मधुबनी' },
  { code: 'SN_VILL_08', subDistrictCode: 'SN_TEH_01', nameEn: 'Pipra', nameHi: 'पिपरा' },

  // Siddharthnagar, Bansi
  { code: 'SN_VILL_09', subDistrictCode: 'SN_TEH_02', nameEn: 'Bansi Dehat', nameHi: 'बांसी देहात' },
  { code: 'SN_VILL_10', subDistrictCode: 'SN_TEH_02', nameEn: 'Lalpur', nameHi: 'लालपुर' },
  { code: 'SN_VILL_11', subDistrictCode: 'SN_TEH_02', nameEn: 'Khesraha Rural', nameHi: 'खेसरहा ग्रामीण' },
  { code: 'SN_VILL_12', subDistrictCode: 'SN_TEH_02', nameEn: 'Semra', nameHi: 'सेमरा' },
  { code: 'SN_VILL_13', subDistrictCode: 'SN_TEH_02', nameEn: 'Chandee', nameHi: 'चंडी' },

  // Siddharthnagar, Shohratgarh
  { code: 'SN_VILL_14', subDistrictCode: 'SN_TEH_05', nameEn: 'Shohratgarh Dehat', nameHi: 'शोहरतगढ़ देहात' },
  { code: 'SN_VILL_15', subDistrictCode: 'SN_TEH_05', nameEn: 'Khairati', nameHi: 'खैराती' },
  { code: 'SN_VILL_16', subDistrictCode: 'SN_TEH_05', nameEn: 'Mudila', nameHi: 'मुदिला' },
  { code: 'SN_VILL_17', subDistrictCode: 'SN_TEH_05', nameEn: 'Barhni Dehat', nameHi: 'बढ़नी देहात' }
];

// GET /api/locations/states
exports.getStates = async (req, res) => {
  try {
    if (req.db) {
      const result = await req.db.query(
        'SELECT official_code AS code, name_en AS "nameEn", name_hi AS "nameHi", location_type AS type FROM states WHERE is_active = true ORDER BY name_en ASC'
      );
      return res.json({ success: true, data: result.rows });
    }
    // Fallback Mock
    res.json({ success: true, data: mockStates });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// GET /api/locations/states/:stateCode/districts
exports.getDistrictsByState = async (req, res) => {
  const { stateCode } = req.params;
  try {
    if (req.db) {
      const result = await req.db.query(
        `SELECT d.official_code AS code, s.official_code AS "stateCode", d.name_en AS "nameEn", d.name_hi AS "nameHi"
         FROM districts d
         INNER JOIN states s ON d.state_id = s.id
         WHERE s.official_code = $1 AND d.is_active = true
         ORDER BY d.name_en ASC`,
        [stateCode]
      );
      return res.json({ success: true, data: result.rows });
    }
    // Fallback Mock
    const filtered = mockDistricts.filter(d => d.stateCode === stateCode);
    res.json({ success: true, data: filtered });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// GET /api/locations/districts/:districtCode/subdistricts
exports.getSubDistrictsByDistrict = async (req, res) => {
  const { districtCode } = req.params;
  try {
    if (req.db) {
      const result = await req.db.query(
        `SELECT sd.official_code AS code, d.official_code AS "districtCode", sd.name_en AS "nameEn", sd.name_hi AS "nameHi"
         FROM sub_districts sd
         INNER JOIN districts d ON sd.district_id = d.id
         WHERE d.official_code = $1 AND sd.is_active = true
         ORDER BY sd.name_en ASC`,
        [districtCode]
      );
      return res.json({ success: true, data: result.rows });
    }
    // Fallback Mock
    const filtered = mockSubDistricts.filter(sd => sd.districtCode === districtCode);
    res.json({ success: true, data: filtered });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// GET /api/locations/subdistricts/:subDistrictCode/villages
exports.getVillagesBySubDistrict = async (req, res) => {
  const { subDistrictCode } = req.params;
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 20;
  const offset = (page - 1) * limit;

  try {
    if (req.db) {
      const countResult = await req.db.query(
        `SELECT COUNT(*) FROM villages v
         INNER JOIN sub_districts sd ON v.sub_district_id = sd.id
         WHERE sd.official_code = $1 AND v.is_active = true`,
        [subDistrictCode]
      );
      const total = parseInt(countResult.rows[0].count);

      const result = await req.db.query(
        `SELECT v.official_code AS code, sd.official_code AS "subDistrictCode", v.name_en AS "nameEn", v.name_hi AS "nameHi"
         FROM villages v
         INNER JOIN sub_districts sd ON v.sub_district_id = sd.id
         WHERE sd.official_code = $1 AND v.is_active = true
         ORDER BY v.name_en ASC
         LIMIT $2 OFFSET $3`,
        [subDistrictCode, limit, offset]
      );

      return res.json({
        success: true,
        data: result.rows,
        pagination: {
          page,
          limit,
          total,
          hasNext: offset + limit < total
        }
      });
    }
    // Fallback Mock
    const filtered = mockVillages.filter(v => v.subDistrictCode === subDistrictCode);
    const paginated = filtered.slice(offset, offset + limit);
    res.json({
      success: true,
      data: paginated,
      pagination: {
        page,
        limit,
        total: filtered.length,
        hasNext: offset + limit < filtered.length
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// GET /api/locations/villages/search
exports.searchVillages = async (req, res) => {
  const { subDistrictCode, query } = req.query;
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 20;
  const offset = (page - 1) * limit;

  if (!subDistrictCode) {
    return res.status(400).json({ success: false, message: 'subDistrictCode query parameter is required' });
  }

  const searchQuery = query ? `%${query.trim()}%` : '%';

  try {
    if (req.db) {
      // Use pg_trgm for indexed prefix/infix matching
      const countResult = await req.db.query(
        `SELECT COUNT(*) FROM villages v
         INNER JOIN sub_districts sd ON v.sub_district_id = sd.id
         WHERE sd.official_code = $1 AND v.is_active = true
         AND (v.name_en ILIKE $2 OR v.name_hi ILIKE $2)`,
        [subDistrictCode, searchQuery]
      );
      const total = parseInt(countResult.rows[0].count);

      const result = await req.db.query(
        `SELECT v.official_code AS code, sd.official_code AS "subDistrictCode", v.name_en AS "nameEn", v.name_hi AS "nameHi"
         FROM villages v
         INNER JOIN sub_districts sd ON v.sub_district_id = sd.id
         WHERE sd.official_code = $1 AND v.is_active = true
         AND (v.name_en ILIKE $2 OR v.name_hi ILIKE $2)
         ORDER BY v.name_en ASC
         LIMIT $3 OFFSET $4`,
        [subDistrictCode, searchQuery, limit, offset]
      );

      return res.json({
        success: true,
        data: result.rows,
        pagination: {
          page,
          limit,
          total,
          hasNext: offset + limit < total
        }
      });
    }

    // Fallback Mock
    let filtered = mockVillages.filter(v => v.subDistrictCode === subDistrictCode);
    if (query) {
      const q = query.trim().toLowerCase();
      filtered = filtered.filter(
        v => v.nameEn.toLowerCase().includes(q) || v.nameHi.toLowerCase().includes(q)
      );
    }
    const paginated = filtered.slice(offset, offset + limit);

    res.json({
      success: true,
      data: paginated,
      pagination: {
        page,
        limit,
        total: filtered.length,
        hasNext: offset + limit < filtered.length
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// GET /api/locations/villages/:villageCode
exports.getVillageDetails = async (req, res) => {
  const { villageCode } = req.params;
  try {
    if (req.db) {
      const result = await req.db.query(
        `SELECT v.official_code AS code, v.name_en AS "nameEn", v.name_hi AS "nameHi",
                sd.official_code AS "subDistrictCode", sd.name_en AS "subDistrictNameEn",
                d.official_code AS "districtCode", d.name_en AS "districtNameEn",
                s.official_code AS "stateCode", s.name_en AS "stateNameEn"
         FROM villages v
         INNER JOIN sub_districts sd ON v.sub_district_id = sd.id
         INNER JOIN districts d ON sd.district_id = d.id
         INNER JOIN states s ON d.state_id = s.id
         WHERE v.official_code = $1 AND v.is_active = true`,
        [villageCode]
      );
      if (result.rows.length === 0) {
        return res.status(404).json({ success: false, message: 'Village not found' });
      }
      return res.json({ success: true, data: result.rows[0] });
    }

    // Fallback Mock
    const village = mockVillages.find(v => v.code === villageCode);
    if (!village) {
      return res.status(404).json({ success: false, message: 'Village not found' });
    }
    
    const subDistrict = mockSubDistricts.find(sd => sd.code === village.subDistrictCode);
    const district = mockDistricts.find(d => d.code === subDistrict.districtCode);
    const state = mockStates.find(s => s.code === district.stateCode);

    res.json({
      success: true,
      data: {
        code: village.code,
        nameEn: village.nameEn,
        nameHi: village.nameHi,
        subDistrictCode: subDistrict.code,
        subDistrictNameEn: subDistrict.nameEn,
        districtCode: district.code,
        districtNameEn: district.nameEn,
        stateCode: state.code,
        stateNameEn: state.nameEn
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
