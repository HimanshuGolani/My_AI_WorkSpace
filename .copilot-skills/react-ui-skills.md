# React UI Skills
Ready-made patterns, component recipes, and hooks for React web development.

---

## SKILL: Reusable Data Table with Sorting and Pagination
```tsx
interface Column<T> { key: keyof T; label: string; sortable?: boolean; render?: (val: T[keyof T], row: T) => React.ReactNode; }
interface DataTableProps<T> { data: T[]; columns: Column<T>[]; pageSize?: number; }

function DataTable<T extends { id: string | number }>({ data, columns, pageSize = 10 }: DataTableProps<T>) {
  const [page, setPage] = useState(0);
  const [sortKey, setSortKey] = useState<keyof T | null>(null);
  const [sortDir, setSortDir] = useState<'asc' | 'desc'>('asc');

  const sorted = useMemo(() => {
    if (!sortKey) return data;
    return [...data].sort((a, b) => {
      const v = a[sortKey] < b[sortKey] ? -1 : a[sortKey] > b[sortKey] ? 1 : 0;
      return sortDir === 'asc' ? v : -v;
    });
  }, [data, sortKey, sortDir]);

  const paged = sorted.slice(page * pageSize, (page + 1) * pageSize);
  const totalPages = Math.ceil(data.length / pageSize);

  return (
    <div>
      <table className="w-full text-sm">
        <thead><tr>{columns.map(c => (
          <th key={String(c.key)} onClick={() => c.sortable && setSortKey(c.key)} className={cn("text-left p-2", c.sortable && "cursor-pointer hover:bg-gray-50")}>
            {c.label} {sortKey === c.key && (sortDir === 'asc' ? '↑' : '↓')}
          </th>
        ))}</tr></thead>
        <tbody>{paged.map(row => (
          <tr key={row.id} className="border-t hover:bg-gray-50">
            {columns.map(c => <td key={String(c.key)} className="p-2">{c.render ? c.render(row[c.key], row) : String(row[c.key])}</td>)}
          </tr>
        ))}</tbody>
      </table>
      <div className="flex gap-2 mt-4 justify-end">
        {Array.from({ length: totalPages }, (_, i) => (
          <button key={i} onClick={() => setPage(i)} className={cn("px-3 py-1 rounded", page === i ? "bg-blue-600 text-white" : "bg-gray-100")}>{i + 1}</button>
        ))}
      </div>
    </div>
  );
}
```

---

## SKILL: useDebounce Hook
```tsx
function useDebounce<T>(value: T, delay = 300): T {
  const [debounced, setDebounced] = useState(value);
  useEffect(() => {
    const t = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(t);
  }, [value, delay]);
  return debounced;
}
// Usage: const debouncedSearch = useDebounce(searchTerm, 400);
```

---

## SKILL: Toast Notification Hook
```tsx
type Toast = { id: string; message: string; type: 'success' | 'error' | 'info' };
const toastStore = create<{ toasts: Toast[]; add: (t: Omit<Toast,'id'>) => void; remove: (id: string) => void }>((set) => ({
  toasts: [],
  add: (t) => set(s => ({ toasts: [...s.toasts, { ...t, id: crypto.randomUUID() }] })),
  remove: (id) => set(s => ({ toasts: s.toasts.filter(t => t.id !== id) })),
}));

export const useToast = () => {
  const { add } = toastStore();
  return {
    success: (message: string) => add({ message, type: 'success' }),
    error: (message: string) => add({ message, type: 'error' }),
    info: (message: string) => add({ message, type: 'info' }),
  };
};
```

---

## SKILL: Protected Route (React Router)
```tsx
const ProtectedRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { isAuthenticated, isLoading } = useAuth();
  if (isLoading) return <Spinner />;
  if (!isAuthenticated) return <Navigate to="/login" replace />;
  return <>{children}</>;
};
```

---

## SKILL: API Client with Interceptors
```tsx
import axios from 'axios';
export const api = axios.create({ baseURL: import.meta.env.VITE_API_URL });
api.interceptors.request.use(cfg => {
  const token = localStorage.getItem('access_token');
  if (token) cfg.headers.Authorization = `Bearer ${token}`;
  return cfg;
});
api.interceptors.response.use(r => r, async err => {
  if (err.response?.status === 401) { /* refresh token logic */ }
  return Promise.reject(err);
});
```

---

## SKILL: Infinite Scroll List
```tsx
const { data, fetchNextPage, hasNextPage, isFetchingNextPage } = useInfiniteQuery({
  queryKey: ['items'],
  queryFn: ({ pageParam = 0 }) => api.get('/items', { params: { page: pageParam, size: 20 } }),
  getNextPageParam: (last) => last.data.hasMore ? last.data.nextPage : undefined,
});
const ref = useIntersectionObserver(() => { if (hasNextPage) fetchNextPage(); });
```