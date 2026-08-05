import { Link } from 'react-router-dom';
import type { ReactNode } from 'react';

interface PageProps {
  title: string;
  backTo?: string;
  children: ReactNode;
  actions?: ReactNode;
}

export function Page({ title, backTo = '/home', children, actions }: PageProps) {
  return (
    <div className="page">
      <div className="topbar">
        <Link to={backTo} className="btn ghost" aria-label="Назад">
          ←
        </Link>
        <h1 className="brand grow" style={{ fontSize: '1.7rem' }}>
          {title}
        </h1>
        {actions}
      </div>
      <div className="stack">{children}</div>
    </div>
  );
}
