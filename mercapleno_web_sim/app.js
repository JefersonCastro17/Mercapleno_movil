/* =============================================================
   MERCAPLENO – Web Simulation JavaScript
   Emula fielmente los flujos del proyecto Flutter/Dart
   API_BASE_URL: http://172.20.10.5:4000  (desde .env)
   Fallback: http://192.168.1.14:4000     (hardcoded en app_config.dart)
   ============================================================= */

const API_BASE_URL = 'http://172.20.10.5:4000'; // valor del .env
const INTERNAL_API_KEY = 'mercapleno123456789';
const TIMEOUT_MS = 10000;

// ─── Estado global (simula AuthController + VentaProvider) ────────────────────
const State = {
  session: null,            // { token, user: { fullName, email, idRol } }
  challenge: null,          // { pendingToken, email, expiresInMinutes }
  authView: 'login',        // login | twoFactor | verifyEmail | requestPasswordReset | resetPassword
  documentTypes: [],
  productos: [],
  cart: [],
  paymentMethod: 'M1',
  filters: { search: '', category: 'Todo', min: null, max: null },
  isSubmitting: false,
};

// ─── Utilidades HTTP (replica ApiClient de Flutter) ───────────────────────────
const Http = {
  _buildHeaders() {
    const headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': INTERNAL_API_KEY,
    };
    if (State.session?.token) {
      headers['Authorization'] = `Bearer ${State.session.token}`;
    }
    return headers;
  },

  async _fetch(method, path, body) {
    const url = `${API_BASE_URL}${path.startsWith('/') ? path : '/' + path}`;
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), TIMEOUT_MS);

    try {
      const opts = {
        method,
        headers: this._buildHeaders(),
        signal: controller.signal,
      };
      if (body !== undefined) opts.body = JSON.stringify(body);

      const res = await fetch(url, opts);
      clearTimeout(timer);

      let data;
      const ct = res.headers.get('content-type') || '';
      if (ct.includes('application/json')) {
        data = await res.json();
      } else {
        const text = await res.text();
        data = text || {};
      }

      if (res.ok) return data;

      // Extrae mensaje de error igual que _extractMessageFromData en Flutter
      const msg = this._extractMessage(data) || `Error ${res.status}`;
      throw { type: 'api', message: msg, status: res.status, data };

    } catch (err) {
      clearTimeout(timer);

      if (err.type === 'api') throw err;

      // Reproduce los tres casos de ApiClient._looksLikeConnectionError
      if (err.name === 'AbortError') {
        throw {
          type: 'timeout',
          message: 'El backend tardó demasiado en responder. Verifica la conexión o la IP configurada.',
          technical: `TimeoutException: La solicitud a ${url} superó los ${TIMEOUT_MS / 1000} segundos.`,
          url,
        };
      }

      // TypeError: Failed to fetch  → SocketException / Connection refused
      throw {
        type: 'connection',
        message: 'No se pudo conectar con el backend. Verifica que esté encendido.',
        technical: `${err.name}: ${err.message}\nURL intentada: ${url}`,
        url,
      };
    }
  },

  _extractMessage(data) {
    if (!data) return null;
    if (typeof data === 'string' && data.trim()) return data.trim();
    if (typeof data === 'object') {
      if (data.message) return data.message;
      if (data.detail) return data.detail;
      if (data.error) return data.error;
      if (data.errors) {
        if (typeof data.errors === 'object' && !Array.isArray(data.errors)) {
          return Object.values(data.errors).flat().join(' ');
        }
        if (Array.isArray(data.errors)) return data.errors.join(' ');
      }
    }
    return null;
  },

  get: (path, params) => {
    let p = path;
    if (params && Object.keys(params).length) {
      const q = new URLSearchParams(params).toString();
      p = `${path}?${q}`;
    }
    return Http._fetch('GET', p);
  },
  post: (path, body) => Http._fetch('POST', path, body ?? {}),
};

// ─── Error handler central (muestra modal de conexión o mensaje inline) ───────
function handleApiError(err, { inlineId, onUiError } = {}) {
  if (err.type === 'connection' || err.type === 'timeout') {
    App.showConnModal(err);
    return;
  }
  // Error HTTP del servidor → mostrar inline
  const msg = err.message || 'Error inesperado. Intenta nuevamente.';
  if (onUiError) onUiError(msg);
  else if (inlineId) showMsg(inlineId, msg, 'error');
}

// ─── Screen router ─────────────────────────────────────────────────────────────
function showScreen(id) {
  document.querySelectorAll('.screen').forEach(s => s.classList.remove('active'));
  document.getElementById(id).classList.add('active');
  window.scrollTo(0, 0);
}

// ─── Mensajes inline ──────────────────────────────────────────────────────────
function showMsg(id, text, type = 'info') {
  const el = document.getElementById(id);
  if (!el) return;
  el.textContent = text;
  el.className = `msg-${type}`;
  el.classList.remove('hidden');
}
function hideMsg(id) {
  const el = document.getElementById(id);
  if (el) el.classList.add('hidden');
}

// ─── Formularios auth ──────────────────────────────────────────────────────────
function showAuthForm(formId, title, subtitle) {
  ['form-login','form-2fa','form-verify-email','form-request-reset','form-reset-password']
    .forEach(id => document.getElementById(id).classList.add('hidden'));
  document.getElementById(formId).classList.remove('hidden');
  if (title) document.getElementById('login-title').textContent = title;
  if (subtitle) document.getElementById('login-subtitle').textContent = subtitle;
  hideMsg('login-info-msg');
  hideMsg('login-error-msg');
}

// ─── APP PRINCIPAL ─────────────────────────────────────────────────────────────
const App = {

  // ── Inicialización (replica main() + authController.initialize()) ──────────
  async init() {
    showScreen('screen-splash');

    // Simula restore session desde SharedPreferences
    await sleep(1200);
    const saved = localStorage.getItem('mercapleno_session');
    if (saved) {
      try {
        State.session = JSON.parse(saved);
        this._routeAfterAuth();
        return;
      } catch (_) {
        localStorage.removeItem('mercapleno_session');
      }
    }
    showScreen('screen-landing');
  },

  // ── Navegación auth ────────────────────────────────────────────────────────
  goLogin() {
    State.authView = 'login';
    showAuthForm('form-login', 'Iniciar sesión', 'Accede usando el backend actual de Mercapleno.');
    showScreen('screen-login');
  },

  goRegister() {
    showScreen('screen-register');
    this._loadDocumentTypes();
  },

  // ── LOGIN (replica AuthController.loginWithCredentials) ────────────────────
  async submitLogin() {
    if (State.isSubmitting) return;

    const email = document.getElementById('login-email').value.trim();
    const password = document.getElementById('login-password').value;

    if (!email || !password) {
      showMsg('login-error-msg', 'Ingresa tu correo y contraseña.', 'error');
      return;
    }

    hideMsg('login-error-msg');
    hideMsg('login-info-msg');
    this._setSubmitting(true, 'btn-login', 'Ingresando...');

    try {
      const data = await Http.post('/api/auth/login', { email, password });

      // El backend puede pedir 2FA: { requiresTwoFactor: true, pendingToken, email, expiresInMinutes }
      if (data.requiresTwoFactor || data.pendingToken) {
        State.challenge = {
          pendingToken: data.pendingToken || data.token,
          email: data.email || email,
          expiresInMinutes: data.expiresInMinutes || 5,
        };
        State.authView = 'twoFactor';
        document.getElementById('two-factor-hint').textContent =
          `Ingresa el código enviado a ${State.challenge.email}. Vence en ${State.challenge.expiresInMinutes} minutos.`;
        showAuthForm('form-2fa', 'Verificación de seguridad', 'Completa el segundo factor para terminar tu acceso.');
      } else {
        // Login directo
        this._saveSession(data, email);
        this._routeAfterAuth();
      }

    } catch (err) {
      // Caso especial: EMAIL_NOT_VERIFIED  (replica _handleApiError en Flutter)
      if (err.status === 403 && err.data?.code === 'EMAIL_NOT_VERIFIED') {
        document.getElementById('verify-email').value = email;
        showAuthForm('form-verify-email', 'Verificar correo', 'Ingresa el código enviado a tu correo para activar la cuenta.');
        showMsg('login-error-msg', 'Debes verificar tu correo antes de iniciar sesión.', 'error');
      } else {
        handleApiError(err, {
          onUiError: msg => showMsg('login-error-msg', msg, 'error'),
        });
      }
    } finally {
      this._setSubmitting(false, 'btn-login', 'Ingresar');
    }
  },

  // ── 2FA (replica AuthController.verifyTwoFactorCode) ──────────────────────
  async submit2FA() {
    if (State.isSubmitting || !State.challenge) return;

    const code = document.getElementById('twofactor-code').value.trim();
    if (!code || code.length !== 6) {
      showMsg('login-error-msg', 'El código debe tener 6 dígitos.', 'error');
      return;
    }

    hideMsg('login-error-msg');
    this._setSubmitting(true, 'btn-2fa', 'Verificando...');

    try {
      const data = await Http.post('/api/auth/verify-login-code', {
        pendingToken: State.challenge.pendingToken,
        code,
      });
      State.challenge = null;
      this._saveSession(data, data.email || '');
      this._routeAfterAuth();
    } catch (err) {
      State.challenge = null;
      if (err.status === 400 || err.status === 401) {
        showAuthForm('form-login', 'Iniciar sesión', 'Accede usando el backend actual de Mercapleno.');
        showMsg('login-info-msg', 'La verificación expiró. Vuelve a iniciar sesión.', 'info');
      }
      handleApiError(err, { onUiError: msg => showMsg('login-error-msg', msg, 'error') });
    } finally {
      this._setSubmitting(false, 'btn-2fa', 'Verificar código');
    }
  },

  cancelTwoFactor() {
    State.challenge = null;
    showAuthForm('form-login', 'Iniciar sesión', 'Accede usando el backend actual de Mercapleno.');
  },

  // ── VERIFY EMAIL ────────────────────────────────────────────────────────────
  showVerifyEmail() {
    const email = document.getElementById('login-email').value.trim();
    document.getElementById('verify-email').value = email;
    showAuthForm('form-verify-email', 'Verificar correo', 'Ingresa el código enviado a tu correo para activar la cuenta.');
  },

  async submitVerifyEmail() {
    if (State.isSubmitting) return;
    const email = document.getElementById('verify-email').value.trim();
    const code = document.getElementById('verify-code').value.trim();
    if (!email || !code) { showMsg('login-error-msg', 'Completa todos los campos.', 'error'); return; }

    hideMsg('login-error-msg');
    this._setSubmitting(true, null, null);
    try {
      const data = await Http.post('/api/auth/verify-email', { email, code });
      showAuthForm('form-login', 'Iniciar sesión', 'Accede usando el backend actual de Mercapleno.');
      showMsg('login-info-msg', data.message || '¡Correo verificado! Ahora puedes iniciar sesión.', 'info');
    } catch (err) {
      handleApiError(err, { onUiError: msg => showMsg('login-error-msg', msg, 'error') });
    } finally {
      this._setSubmitting(false, null, null);
    }
  },

  async resendVerification() {
    const email = document.getElementById('verify-email').value.trim();
    if (!email) { showMsg('login-error-msg', 'Ingresa tu correo.', 'error'); return; }
    try {
      const data = await Http.post('/api/auth/resend-verification', { email });
      showMsg('login-info-msg', data.message || 'Código reenviado. Revisa tu bandeja de entrada.', 'info');
    } catch (err) {
      handleApiError(err, { onUiError: msg => showMsg('login-error-msg', msg, 'error') });
    }
  },

  cancelVerify() {
    showAuthForm('form-login', 'Iniciar sesión', 'Accede usando el backend actual de Mercapleno.');
  },

  // ── FORGOT PASSWORD ─────────────────────────────────────────────────────────
  showForgotPassword() {
    const email = document.getElementById('login-email').value.trim();
    document.getElementById('reset-req-email').value = email;
    showAuthForm('form-request-reset', 'Recuperar contraseña', 'Solicita un código para recuperar tu contraseña.');
  },

  async submitRequestReset() {
    if (State.isSubmitting) return;
    const email = document.getElementById('reset-req-email').value.trim();
    if (!email) { showMsg('login-error-msg', 'Ingresa tu correo.', 'error'); return; }

    hideMsg('login-error-msg');
    this._setSubmitting(true, null, null);
    try {
      const data = await Http.post('/api/auth/request-password-reset', { email });
      document.getElementById('reset-email').value = email;
      showAuthForm('form-reset-password', 'Actualizar contraseña', 'Ingresa el código recibido y define tu nueva contraseña.');
      showMsg('login-info-msg', data.message || 'Código enviado. Revisa tu correo.', 'info');
    } catch (err) {
      handleApiError(err, { onUiError: msg => showMsg('login-error-msg', msg, 'error') });
    } finally {
      this._setSubmitting(false, null, null);
    }
  },

  async submitResetPassword() {
    if (State.isSubmitting) return;
    const email = document.getElementById('reset-email').value.trim();
    const code = document.getElementById('reset-code').value.trim();
    const newPass = document.getElementById('reset-new-pass').value;
    const confirm = document.getElementById('reset-confirm-pass').value;

    if (!email || !code || !newPass || !confirm) { showMsg('login-error-msg', 'Completa todos los campos.', 'error'); return; }
    if (newPass.length < 6) { showMsg('login-error-msg', 'La contraseña debe tener al menos 6 caracteres.', 'error'); return; }
    if (newPass !== confirm) { showMsg('login-error-msg', 'Las contraseñas no coinciden.', 'error'); return; }

    hideMsg('login-error-msg');
    this._setSubmitting(true, null, null);
    try {
      const data = await Http.post('/api/auth/reset-password', { email, code, newPassword: newPass });
      showAuthForm('form-login', 'Iniciar sesión', 'Accede usando el backend actual de Mercapleno.');
      showMsg('login-info-msg', data.message || '¡Contraseña actualizada! Ya puedes iniciar sesión.', 'info');
    } catch (err) {
      handleApiError(err, { onUiError: msg => showMsg('login-error-msg', msg, 'error') });
    } finally {
      this._setSubmitting(false, null, null);
    }
  },

  cancelForgot() {
    showAuthForm('form-login', 'Iniciar sesión', 'Accede usando el backend actual de Mercapleno.');
  },

  // ── REGISTER (replica AuthController.register) ─────────────────────────────
  async submitRegister() {
    if (State.isSubmitting) return;

    const nombre = document.getElementById('reg-nombre').value.trim();
    const apellido = document.getElementById('reg-apellido').value.trim();
    const email = document.getElementById('reg-email').value.trim();
    const password = document.getElementById('reg-password').value;
    const confirm = document.getElementById('reg-confirm-password').value;
    const docType = document.getElementById('reg-doc-type').value;
    const docNum = document.getElementById('reg-doc-num').value.trim();

    hideMsg('reg-error-msg');
    hideMsg('reg-info-msg');

    if (!nombre || !apellido || !email || !password || !docNum) {
      showMsg('reg-error-msg', 'Completa todos los campos.', 'error'); return;
    }
    if (password.length < 6) {
      showMsg('reg-error-msg', 'La contraseña debe tener al menos 6 caracteres.', 'error'); return;
    }
    if (password !== confirm) {
      showMsg('reg-error-msg', 'Las contraseñas no coinciden.', 'error'); return;
    }

    this._setSubmitting(true, 'btn-register', 'Creando cuenta...');

    try {
      // RegisterRequestModel.toJson() replica
      const body = {
        nombre,
        apellido,
        email,
        password,
        idTipoDocumento: docType || undefined,
        numeroDocumento: docNum,
      };
      const data = await Http.post('/api/auth/register', body);

      // Después del registro → verifyEmail (como en Flutter)
      document.getElementById('verify-email').value = email;
      showScreen('screen-login');
      showAuthForm('form-verify-email', 'Verificar correo', 'Ingresa el código enviado a tu correo para activar la cuenta.');
      showMsg('login-info-msg', data.message || 'Cuenta creada. Revisa tu correo para verificarla.', 'info');

    } catch (err) {
      handleApiError(err, { onUiError: msg => showMsg('reg-error-msg', msg, 'error') });
    } finally {
      this._setSubmitting(false, 'btn-register', 'Crear cuenta');
    }
  },

  async _loadDocumentTypes() {
    const sel = document.getElementById('reg-doc-type');
    sel.innerHTML = '<option value="">Cargando tipos...</option>';
    try {
      const data = await Http.get('/api/auth/document-types');
      const types = Array.isArray(data) ? data : (data.data || data.types || []);
      sel.innerHTML = '';
      if (!types.length) {
        sel.innerHTML = '<option value="">Sin tipos disponibles</option>';
        return;
      }
      types.forEach(t => {
        const opt = document.createElement('option');
        opt.value = t.id || t.idTipoDocumento || t.value || '';
        opt.textContent = t.nombre || t.name || t.label || opt.value;
        sel.appendChild(opt);
      });
    } catch (err) {
      sel.innerHTML = '<option value="">Error al cargar tipos</option>';
      // No mostramos modal aquí, solo silencia como hace Flutter (_documentTypesError)
    }
  },

  // ── LOGOUT ─────────────────────────────────────────────────────────────────
  async logout() {
    localStorage.removeItem('mercapleno_session');
    State.session = null;
    State.cart = [];
    State.productos = [];
    showScreen('screen-landing');
  },

  // ── ROUTING DESPUÉS DE AUTH ────────────────────────────────────────────────
  _routeAfterAuth() {
    const idRol = State.session?.user?.idRol ?? 3;
    if (idRol === 1) {
      // Administrador
      document.getElementById('admin-name').textContent = this._firstName();
      document.getElementById('admin-avatar').textContent = this._avatarLetter();
      showScreen('screen-home-admin');
    } else if (idRol === 2) {
      // Empleado
      document.getElementById('empleado-name').textContent = this._firstName();
      document.getElementById('empleado-avatar').textContent = this._avatarLetter();
      showScreen('screen-home-empleado');
    } else {
      // Cliente → catálogo directo
      this.loadCatalogo();
      showScreen('screen-catalogo');
    }
  },

  _firstName() {
    const full = State.session?.user?.fullName || State.session?.user?.nombre || '';
    return full.trim().split(' ')[0] || 'Usuario';
  },
  _avatarLetter() {
    return (this._firstName()[0] || 'U').toUpperCase();
  },

  // ── CATÁLOGO (replica VentaProvider.loadCatalogo) ─────────────────────────
  async loadCatalogo() {
    document.getElementById('catalogo-loader').classList.remove('hidden');
    document.getElementById('catalogo-grid').classList.add('hidden');
    document.getElementById('catalogo-error').classList.add('hidden');

    const params = {};
    if (State.filters.search) params.search = State.filters.search;
    if (State.filters.category && State.filters.category !== 'Todo') params.category = State.filters.category;
    if (State.filters.min != null) params.precioMin = State.filters.min;
    if (State.filters.max != null) params.precioMax = State.filters.max;

    try {
      const data = await Http.get('/api/sales/products', params);
      State.productos = Array.isArray(data) ? data : (data.products || data.data || []);
      this._renderCatalogo();
      this._populateCategories();
    } catch (err) {
      document.getElementById('catalogo-loader').classList.add('hidden');
      document.getElementById('catalogo-error').classList.remove('hidden');
      document.getElementById('catalogo-error-msg').textContent =
        err.type === 'connection' || err.type === 'timeout'
          ? err.message
          : (err.message || 'Error de conexión con el backend.');
      // También muestra el modal de diagnóstico
      if (err.type === 'connection' || err.type === 'timeout') this.showConnModal(err);
    }
  },

  _productImageUrl(imagen) {
    if (!imagen) return null;
    if (imagen.startsWith('http')) return imagen;
    let clean = imagen.trim().replace(/^(\.\.\\/|\.\\/|\/)/, '');
    clean = clean.replace(/\\/g, '/');
    if (clean.startsWith('uploads/')) clean = clean.replace('uploads/', '');
    return `${API_BASE_URL}/uploads/${clean}`;
  },

  _renderCatalogo() {
    document.getElementById('catalogo-loader').classList.add('hidden');
    const grid = document.getElementById('catalogo-grid');
    grid.classList.remove('hidden');
    grid.innerHTML = '';

    if (!State.productos.length) {
      grid.innerHTML = '<p style="grid-column:1/-1;text-align:center;color:#9CA3AF;padding:32px">No se encontraron productos.</p>';
      return;
    }

    State.productos.forEach((p, i) => {
      const id = p.id || p.id_producto || i;
      const nombre = p.nombre || p.nombre_producto || 'Sin nombre';
      const descripcion = p.descripcion || p.desc_producto || 'Sin descripción';
      const precio = parseFloat(p.price ?? p.precio ?? 0);
      const imagen = p.image || p.imagen || '';
      const imgUrl = this._productImageUrl(imagen);

      const card = document.createElement('div');
      card.className = 'product-card';
      card.innerHTML = `
        <div class="product-img-wrap">
          ${imgUrl
            ? `<img src="${imgUrl}" alt="${nombre}" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
               <div class="product-img-placeholder" style="display:none">🖼️</div>`
            : `<div class="product-img-placeholder">🖼️</div>`}
        </div>
        <div class="product-info">
          <div class="product-name">${nombre}</div>
          <div class="product-desc">${descripcion}</div>
          <div class="product-price">$${precio.toLocaleString('es-CO')}</div>
          <button class="btn-add-cart" onclick="App.addToCart(${JSON.stringify(JSON.stringify({id, nombre, descripcion, precio, imagen, categoria: p.category || p.categoria || 'General'}))})">
            🛒 Agregar
          </button>
        </div>`;
      grid.appendChild(card);
    });
  },

  _populateCategories() {
    const sel = document.getElementById('filter-cat');
    const cats = [...new Set(State.productos.map(p => p.category || p.categoria || 'General'))];
    const current = sel.value;
    sel.innerHTML = '<option value="Todo">Todo</option>';
    cats.forEach(c => {
      const opt = document.createElement('option');
      opt.value = c;
      opt.textContent = c;
      if (c === current) opt.selected = true;
      sel.appendChild(opt);
    });
  },

  // ── FILTROS ────────────────────────────────────────────────────────────────
  showFilterSheet() {
    const sheet = document.getElementById('filter-sheet');
    sheet.classList.toggle('hidden');
  },

  applyFilters() {
    State.filters.search = document.getElementById('filter-search').value.trim();
    State.filters.category = document.getElementById('filter-cat').value;
    const min = parseFloat(document.getElementById('filter-min').value);
    const max = parseFloat(document.getElementById('filter-max').value);
    State.filters.min = isNaN(min) ? null : min;
    State.filters.max = isNaN(max) ? null : max;
    document.getElementById('filter-sheet').classList.add('hidden');
    this.loadCatalogo();
  },

  resetFilters() {
    State.filters = { search: '', category: 'Todo', min: null, max: null };
    document.getElementById('filter-search').value = '';
    document.getElementById('filter-cat').value = 'Todo';
    document.getElementById('filter-min').value = '';
    document.getElementById('filter-max').value = '';
    document.getElementById('filter-sheet').classList.add('hidden');
    this.loadCatalogo();
  },

  // ── CARRITO (replica VentaProvider) ───────────────────────────────────────
  addToCart(jsonStr) {
    const producto = JSON.parse(jsonStr);
    const idx = State.cart.findIndex(i => i.id === producto.id);
    if (idx !== -1) {
      State.cart[idx].cantidad++;
    } else {
      State.cart.push({ ...producto, cantidad: 1 });
    }
    this._updateCartBadge();
    this.showSnack(`"${producto.nombre}" agregado al carrito`);
  },

  _updateCartBadge() {
    const count = State.cart.reduce((s, i) => s + i.cantidad, 0);
    const badge = document.getElementById('cart-count');
    if (count > 0) {
      badge.textContent = count;
      badge.style.display = 'flex';
    } else {
      badge.style.display = 'none';
    }
  },

  goCarrito() {
    this._renderCarrito();
    showScreen('screen-carrito');
  },

  backToCatalogo() {
    showScreen('screen-catalogo');
  },

  _renderCarrito() {
    const list = document.getElementById('carrito-items');
    const empty = document.getElementById('carrito-empty');
    const content = document.getElementById('carrito-content');
    list.innerHTML = '';

    if (!State.cart.length) {
      empty.classList.remove('hidden');
      content.style.display = 'none';
      return;
    }
    empty.classList.add('hidden');
    content.style.display = 'block';

    State.cart.forEach((item, idx) => {
      const imgUrl = this._productImageUrl(item.imagen);
      const div = document.createElement('div');
      div.className = 'carrito-item';
      div.innerHTML = `
        <div class="carrito-item-img">
          ${imgUrl ? `<img src="${imgUrl}" style="width:56px;height:56px;object-fit:cover;border-radius:10px" onerror="this.outerHTML='🛍️'">` : '🛍️'}
        </div>
        <div class="carrito-item-info">
          <div class="carrito-item-name">${item.nombre}</div>
          <div class="carrito-item-price">$${(item.precio * item.cantidad).toLocaleString('es-CO')}</div>
        </div>
        <div class="qty-control">
          <button class="qty-btn" onclick="App.updateQty(${idx}, ${item.cantidad - 1})">−</button>
          <span class="qty-value">${item.cantidad}</span>
          <button class="qty-btn" onclick="App.updateQty(${idx}, ${item.cantidad + 1})">+</button>
        </div>`;
      list.appendChild(div);
    });

    // Totales (replica VentaTotals.calculate)
    const subtotal = State.cart.reduce((s, i) => s + i.precio * i.cantidad, 0);
    const iva = subtotal * 0.19;
    const total = subtotal + iva;
    document.getElementById('summary-subtotal').textContent = `$${subtotal.toLocaleString('es-CO', {maximumFractionDigits:0})}`;
    document.getElementById('summary-iva').textContent = `$${iva.toLocaleString('es-CO', {maximumFractionDigits:0})}`;
    document.getElementById('summary-total').textContent = `$${total.toLocaleString('es-CO', {maximumFractionDigits:0})}`;
  },

  updateQty(idx, newQty) {
    if (newQty <= 0) {
      State.cart.splice(idx, 1);
    } else {
      State.cart[idx].cantidad = newQty;
    }
    this._updateCartBadge();
    this._renderCarrito();
  },

  // ── CHECKOUT (replica VentaProvider.processCheckout) ──────────────────────
  async checkout() {
    if (!State.cart.length) return;

    const subtotal = State.cart.reduce((s, i) => s + i.precio * i.cantidad, 0);
    const total = subtotal * 1.19;
    const idMetodo = document.getElementById('payment-method').value;

    const body = {
      items: State.cart.map(i => ({ id: i.id, cantidad: i.cantidad })),
      total,
      idMetodo,
    };

    try {
      const data = await Http.post('/api/sales/orders', body);
      State.cart = [];
      this._updateCartBadge();
      this.showSnack('¡Venta registrada exitosamente!');
      this.backToCatalogo();
    } catch (err) {
      if (err.type === 'connection' || err.type === 'timeout') {
        this.showConnModal(err);
      } else {
        this.showSnack(`Error al procesar el pago: ${err.message}`);
      }
    }
  },

  // ── ADMIN: PRODUCTOS ──────────────────────────────────────────────────────
  goProductos() {
    showScreen('screen-productos');
    this.loadProductosAdmin();
  },

  async loadProductosAdmin() {
    document.getElementById('productos-loader').classList.remove('hidden');
    document.getElementById('productos-table-wrap').classList.add('hidden');
    document.getElementById('productos-error').classList.add('hidden');

    try {
      const data = await Http.get('/api/sales/products');
      const items = Array.isArray(data) ? data : (data.products || data.data || []);
      const tbody = document.getElementById('productos-tbody');
      tbody.innerHTML = '';
      items.forEach((p, i) => {
        const nombre = p.nombre || p.nombre_producto || 'Sin nombre';
        const precio = parseFloat(p.price ?? p.precio ?? 0);
        const categoria = p.category || p.categoria || 'General';
        const imgUrl = this._productImageUrl(p.image || p.imagen || '');
        const tr = document.createElement('tr');
        tr.innerHTML = `
          <td>${i + 1}</td>
          <td>${imgUrl ? `<img class="table-img" src="${imgUrl}" onerror="this.outerHTML='🖼️'">` : '🖼️'}</td>
          <td>${nombre}</td>
          <td>$${precio.toLocaleString('es-CO')}</td>
          <td>${categoria}</td>`;
        tbody.appendChild(tr);
      });
      document.getElementById('productos-loader').classList.add('hidden');
      document.getElementById('productos-table-wrap').classList.remove('hidden');
    } catch (err) {
      document.getElementById('productos-loader').classList.add('hidden');
      document.getElementById('productos-error').classList.remove('hidden');
      document.getElementById('productos-error-msg').textContent = err.message || 'No se pudo conectar con el backend.';
      if (err.type === 'connection' || err.type === 'timeout') this.showConnModal(err);
    }
  },

  // ── ADMIN: USUARIOS ───────────────────────────────────────────────────────
  goUsersAdmin() {
    showScreen('screen-users-admin');
    this.loadUsersAdmin();
  },

  async loadUsersAdmin() {
    document.getElementById('users-loader').classList.remove('hidden');
    document.getElementById('users-table-wrap').classList.add('hidden');
    document.getElementById('users-error').classList.add('hidden');

    try {
      const data = await Http.get('/api/users');
      const items = Array.isArray(data) ? data : (data.users || data.data || []);
      const tbody = document.getElementById('users-tbody');
      tbody.innerHTML = '';
      items.forEach((u, i) => {
        const nombre = u.fullName || `${u.nombre || ''} ${u.apellido || ''}`.trim() || 'Sin nombre';
        const email = u.email || '-';
        const rolMap = { 1: '👑 Admin', 2: '👷 Empleado', 3: '🛍️ Cliente' };
        const rol = rolMap[u.idRol] || `Rol ${u.idRol}`;
        const estado = u.emailVerified || u.verificado ? '✅ Activo' : '⏳ Pendiente';
        const tr = document.createElement('tr');
        tr.innerHTML = `<td>${i+1}</td><td>${nombre}</td><td>${email}</td><td>${rol}</td><td>${estado}</td>`;
        tbody.appendChild(tr);
      });
      document.getElementById('users-loader').classList.add('hidden');
      document.getElementById('users-table-wrap').classList.remove('hidden');
    } catch (err) {
      document.getElementById('users-loader').classList.add('hidden');
      document.getElementById('users-error').classList.remove('hidden');
      document.getElementById('users-error-msg').textContent = err.message || 'No se pudo cargar usuarios.';
      if (err.type === 'connection' || err.type === 'timeout') this.showConnModal(err);
    }
  },

  backToAdmin() {
    const idRol = State.session?.user?.idRol ?? 1;
    showScreen(idRol === 2 ? 'screen-home-empleado' : 'screen-home-admin');
  },

  // ── MODAL DE ERROR DE CONEXIÓN ─────────────────────────────────────────────
  showConnModal(err) {
    const isTimeout = err.type === 'timeout';
    const url = err.url || API_BASE_URL;

    const body = document.getElementById('conn-modal-body');
    body.innerHTML = `
      <p>${isTimeout
        ? 'La solicitud al servidor tardó más de 10 segundos sin respuesta.'
        : 'La app no pudo alcanzar el servidor de Mercapleno.'}</p>

      <div class="error-block">${err.technical || err.message}</div>

      <p><strong>Posibles causas y soluciones:</strong></p>
      <ul class="fix-list">
        <li>El servidor Node.js / NestJS no está corriendo. Ejecuta <code>npm run start:dev</code> en el backend.</li>
        <li>La IP configurada <strong>${API_BASE_URL}</strong> no corresponde a la red actual. Actualiza <code>.env → API_BASE_URL</code> con la IP real de tu máquina.</li>
        ${isTimeout
          ? `<li>Puede existir un firewall o antivirus bloqueando el puerto <strong>4000</strong>. Verifica las reglas de red.</li>`
          : `<li>El puerto <strong>4000</strong> está bloqueado o la IP no es alcanzable desde este dispositivo.</li>`}
        <li>Si usas hotspot móvil, la IP del .env era <strong>172.20.10.5</strong> pero puede haber cambiado al reconectarte.</li>
        <li>Revisa en la consola del navegador (F12 → Network) si hay errores CORS o de red más específicos.</li>
      </ul>
    `;
    document.getElementById('conn-modal').classList.remove('hidden');
  },

  closeConnModal() {
    document.getElementById('conn-modal').classList.add('hidden');
  },

  // ── HELPERS ───────────────────────────────────────────────────────────────
  showSnack(msg) {
    const sb = document.getElementById('snackbar');
    sb.textContent = msg;
    sb.classList.remove('hidden');
    clearTimeout(App._snackTimer);
    App._snackTimer = setTimeout(() => sb.classList.add('hidden'), 3200);
  },

  _setSubmitting(loading, btnId, loadingLabel) {
    State.isSubmitting = loading;
    if (btnId) {
      const btn = document.getElementById(btnId);
      if (btn) {
        btn.disabled = loading;
        if (loading && loadingLabel) btn.textContent = loadingLabel;
        else if (!loading && loadingLabel !== null) btn.textContent = loadingLabel;
      }
    }
  },

  _saveSession(data, email) {
    // Normaliza la respuesta del backend (puede venir como data.token o data.accessToken)
    const token = data.token || data.accessToken || '';
    const user = data.user || {
      fullName: data.nombre ? `${data.nombre} ${data.apellido || ''}`.trim() : email,
      email: data.email || email,
      idRol: data.idRol || data.rol || 3,
    };
    State.session = { token, user };
    localStorage.setItem('mercapleno_session', JSON.stringify(State.session));
  },
};

// ─── Utilidad sleep ────────────────────────────────────────────────────────────
function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

// ─── Arranque ─────────────────────────────────────────────────────────────────
window.addEventListener('DOMContentLoaded', () => App.init());
