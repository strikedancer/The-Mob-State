import { Request, Response, NextFunction } from 'express';

export interface ApiError extends Error {
  statusCode?: number;
  details?: unknown;
}

export const errorHandler = (err: ApiError, req: Request, res: Response, _next: NextFunction) => {
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal Server Error';

  // Log error for debugging
  console.error(`[ERROR] ${statusCode} - ${message}`, {
    url: req.url,
    method: req.method,
    error: err.details || err.stack,
  });

  // Don't expose stack traces in production
  const response: {
    error: string;
    message: string;
    details?: unknown;
  } = {
    error: statusCode >= 500 ? 'server_error' : 'client_error',
    message,
  };

  // Include details only in development
  if (process.env.NODE_ENV === 'development' && err.details) {
    response.details = err.details;
  }

  res.status(statusCode).json(response);
};

export const notFoundHandler = (req: Request, res: Response) => {
  res.status(404).json({
    error: 'not_found',
    message: `Route ${req.method} ${req.url} not found`,
  });
};
