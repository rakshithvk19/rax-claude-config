# Naming

1. Name the concept, not the container it lives in or the shape it happens to have

2. Use the word the project already has
   - Search the codebase for the concept before naming it
   - A synonym for an existing word splits one idea into two names
     - Example: `Parser` and `parseX` for turning `unknown` into a type, `*Client` for a remote proxy

3. Reject container nouns
   - `Area`, `Environment`, `Platform`, `Context`, `State`, `Parts`, `Projection`, `Record`, `Manager`, `Attempt` and `Plan` describe a bag, not a thing
   - Exception: keep a platform's own word when naming that platform's surface (`ChromeStorageArea` mirrors `chrome.storage.StorageArea`)

4. Don't use past-participle adjectives
   - Not `MessagedDeviceKeyService`
   - Name what the thing is: a client, a proxy, a cache

5. Say each thing once
   - No tautologies: not `StorageBackingStore`
   - No stutter: write `payloads.read(key)`, not `payloads.readPayload(key)`
   - A file name doesn't repeat its folder: not `device-key/DeviceKeyFailureKind.ts`

6. Give one concept one spelling
   - Not `remove`, `erase` and `delete` across three layers of the same operation

7. Make the name match the signature
   - A `serialise` that returns an object graph instead of a string is lying
   - An `Inspector` whose return value gets persisted is lying too

8. Keep names short
   - Cut every word the name doesn't need
   - Not `wouldStillShowTheReplacePageOnThePasswordResetForm`
   - Write `resetFormWouldStillShowTheReplacePage`
   - When I call a method, class or variable "too verbose", I mean the name, not the body

9. Name tests after the feature, in the user's words
   - Name spec files and `describe` blocks after what the user does, not the mechanism the code reuses
   - Not `device-key-reset-device-password.spec.ts`
   - Write `reset-device-password-with-recovery-phrase.spec.ts`
   - Keep mechanism words only where the user sees them on screen

10. If the project's docs give naming conventions, follow those instead
