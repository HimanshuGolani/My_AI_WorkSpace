# React Native Skills
Ready-made screen templates, hooks, and native patterns for React Native / Expo development.

---

## SKILL: Bottom Sheet Modal (Gorhom)
```tsx
import BottomSheet, { BottomSheetView } from '@gorhom/bottom-sheet';
const snapPoints = useMemo(() => ['25%', '50%', '90%'], []);
const sheetRef = useRef<BottomSheet>(null);
// Open: sheetRef.current?.expand()  Close: sheetRef.current?.close()
<BottomSheet ref={sheetRef} index={-1} snapPoints={snapPoints} enablePanDownToClose>
  <BottomSheetView style={styles.content}>
    {/* content */}
  </BottomSheetView>
</BottomSheet>
```

---

## SKILL: Secure Token Storage
```tsx
import * as SecureStore from 'expo-secure-store';
// NEVER use AsyncStorage for tokens — always SecureStore
export const tokenStorage = {
  get: (key: string) => SecureStore.getItemAsync(key),
  set: (key: string, val: string) => SecureStore.setItemAsync(key, val),
  delete: (key: string) => SecureStore.deleteItemAsync(key),
};
```

---

## SKILL: FlashList (High Performance List)
```tsx
import { FlashList } from '@shopify/flash-list';
<FlashList
  data={items}
  renderItem={({ item }) => <ItemCard item={item} />}
  estimatedItemSize={80}
  keyExtractor={item => item.id}
  onEndReached={fetchNextPage}
  onEndReachedThreshold={0.5}
  ListEmptyComponent={<EmptyState />}
  ListFooterComponent={isFetchingNextPage ? <Spinner /> : null}
/>
```

---

## SKILL: useAppState Hook
```tsx
function useAppState() {
  const [state, setState] = useState(AppState.currentState);
  useEffect(() => {
    const sub = AppState.addEventListener('change', setState);
    return () => sub.remove();
  }, []);
  return state; // 'active' | 'background' | 'inactive'
}
```

---

## SKILL: Haptic Feedback
```tsx
import * as Haptics from 'expo-haptics';
// On button press: Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium)
// On success: Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success)
// On error: Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error)
```

---

## SKILL: Network-aware Query
```tsx
import NetInfo from '@react-native-community/netinfo';
function useNetworkAwareQuery<T>(queryKey: string[], queryFn: () => Promise<T>) {
  const [isOnline, setIsOnline] = useState(true);
  useEffect(() => { return NetInfo.addEventListener(s => setIsOnline(!!s.isConnected)); }, []);
  return useQuery({ queryKey, queryFn, enabled: isOnline, networkMode: 'offlineFirst' });
}
```

---

## SKILL: Splash Screen + Font Loading
```tsx
import * as SplashScreen from 'expo-splash-screen';
import { useFonts } from 'expo-font';
SplashScreen.preventAutoHideAsync();
export default function RootLayout() {
  const [fontsLoaded] = useFonts({ 'Inter-Regular': require('./assets/fonts/Inter-Regular.ttf') });
  const onReady = useCallback(async () => {
    if (fontsLoaded) await SplashScreen.hideAsync();
  }, [fontsLoaded]);
  if (!fontsLoaded) return null;
  return <Slot onLayout={onReady} />;
}
```