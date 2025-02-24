import express, { Request, Response } from 'express';
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req: Request, res: Response) => {
  res.json({ message: 'Welcome to the simple Node.js server!' });
});

app.get('/health', (req: Request, res: Response) => {
  res.json({ status: 'OK' });
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
}); 