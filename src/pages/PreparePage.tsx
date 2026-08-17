import { Navigate, useParams } from 'react-router-dom';

/** Короткая подготовка перед боссом — тот же бой в режиме prepare. */
export function PreparePage() {
  const { locationId = 'village' } = useParams();
  return <Navigate to={`/battle/${locationId}/prepare`} replace />;
}
