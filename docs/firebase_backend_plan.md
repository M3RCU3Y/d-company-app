# Firebase Backend Plan

## Phase 1

- Firebase Auth with email/password for diner accounts.
- Firestore collections for:
  - `users`
  - `restaurants`
  - `reservations`
  - `favorites`
- Cloud Messaging reserved for reservation confirmations and favorite-restaurant alerts.

## Proposed collection shapes

- `users/{userId}`
  - `name`
  - `email`
  - `phone`
  - `preferredDiningArea`
  - `notificationPreferences`
- `restaurants/{restaurantId}`
  - `ownerId`
  - `name`
  - `location`
  - `address`
  - `cuisine`
  - `hours`
  - `seatingCapacity`
  - `approvalStatus`
- `reservations/{reservationId}`
  - `restaurantId`
  - `userId`
  - `userName`
  - `partySize`
  - `dateTime`
  - `status`
  - `note`
- `favorites/{userId}/restaurants/{restaurantId}`

## Implementation approach

- Keep repository interfaces as the seam between UI/controllers and Firebase.
- Start by adding Firebase-backed repository implementations beside the mock ones.
- Swap implementations in `AppServices.bootstrap()` once credentials and SDK setup are ready.
- Keep admin approval and restaurant onboarding flows on the same Firestore restaurant record to avoid split ownership state.

## Notifications

- Trigger Cloud Messaging from reservation status changes and favorite-restaurant campaigns later.
- Keep current in-app notification preferences screen as the future configuration surface.
