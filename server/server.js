const jsonServer = require('json-server');
const cors = require('cors');
const server = jsonServer.create();
const router = jsonServer.router('./data.json');
const middlewares = jsonServer.defaults();

server.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
server.use(jsonServer.bodyParser);
server.use(middlewares);

// ─── POST /login ────────────────────────────────────────────────────────────
server.post('/login', (req, res) => {
  const { email, password } = req.body;
  if (!email || !password)
    return res.status(400).json({ error: 'Email and password are required.' });

  const db = router.db;
  const user = db.get('users').find({ email, password }).value();
  if (!user) return res.status(401).json({ error: 'Invalid email or password.' });

  return res.status(200).json({
    message: 'Login successful',
    user: {
      id: user.id, name: user.name, email: user.email, image: user.image,
      favorites: user.favorites, notifications: user.notifications,
      my_properties: user.my_properties,
    },
  });
});

// ─── POST /register ─────────────────────────────────────────────────────────
server.post('/register', (req, res) => {
  const { name, email, password } = req.body;
  if (!name || !email || !password)
    return res.status(400).json({ error: 'Name, email and password are required.' });

  const db = router.db;
  if (db.get('users').find({ email }).value())
    return res.status(409).json({ error: 'Email already in use.' });

  const newId = 'u' + (db.get('users').value().length + 1) + '_' + Date.now();
  const newUser = {
    id: newId, name, email, password,
    image: 'assets/images/images.png',
    notifications: [], favorites: [], my_properties: [],
  };
  db.get('users').push(newUser).write();

  return res.status(201).json({
    message: 'Registration successful',
    user: {
      id: newUser.id, name: newUser.name, email: newUser.email,
      image: newUser.image, favorites: newUser.favorites,
      notifications: newUser.notifications, my_properties: newUser.my_properties,
    },
  });
});

server.use(router);

const PORT = 3000;
server.listen(PORT, () => {
  console.log(`✅  JSON Server  →  http://localhost:${PORT}`);
  console.log(`   POST /login        →  authenticate user`);
  console.log(`   POST /register     →  create new user`);
  console.log(`   GET  /properties   →  list all properties`);
  console.log(`   GET  /users/:id    →  get user by id`);
  console.log(`   PATCH /users/:id   →  update user`);
});
