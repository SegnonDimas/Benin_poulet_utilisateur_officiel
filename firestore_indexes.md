# Index Firestore nécessaires

## Collection: products

### Index 1: sellerId + createdAt (pour le tri des produits par vendeur)
```json
{
  "collectionGroup": "products",
  "queryScope": "COLLECTION",
  "fields": [
    {
      "fieldPath": "sellerId",
      "order": "ASCENDING"
    },
    {
      "fieldPath": "createdAt",
      "order": "DESCENDING"
    }
  ]
}
```

### Index 2: sellerId + status (pour filtrer les produits par vendeur et statut)
```json
{
  "collectionGroup": "products",
  "queryScope": "COLLECTION",
  "fields": [
    {
      "fieldPath": "sellerId",
      "order": "ASCENDING"
    },
    {
      "fieldPath": "status",
      "order": "ASCENDING"
    }
  ]
}
```

### Index 2: status + category (pour le filtrage par catégorie)
```json
{
  "collectionGroup": "products",
  "queryScope": "COLLECTION",
  "fields": [
    {
      "fieldPath": "status",
      "order": "ASCENDING"
    },
    {
      "fieldPath": "category",
      "order": "ASCENDING"
    }
  ]
}
```

### Index 3: storeId + status (pour les produits d'une boutique)
```json
{
  "collectionGroup": "products",
  "queryScope": "COLLECTION",
  "fields": [
    {
      "fieldPath": "storeId",
      "order": "ASCENDING"
    },
    {
      "fieldPath": "status",
      "order": "ASCENDING"
    }
  ]
}
```

## Instructions pour créer les index

1. Allez sur la [Console Firebase](https://console.firebase.google.com/)
2. Sélectionnez votre projet
3. Allez dans Firestore Database > Indexes
4. Cliquez sur "Create Index"
5. Créez les index ci-dessus

## Index automatique

Si vous préférez créer l'index automatiquement, cliquez sur le lien dans l'erreur :
```
https://console.firebase.google.com/v1/r/project/beninpoulet-8f04a/firestore/indexes?create_composite=ClJwcm9qZWN0cy9iZW5pbnBvdWxldC04ZjA0YS9kYXRhYmFzZXMvKGRlZmF1bHQpL2NvbGxlY3Rpb25Hcm91cHMvcHJvZHVjdHMvaW5kZXhlcy9fEAEaDAoIc2VsbGVySWQQARoNCgljcmVhdGVkQXQQAhoMCghfX25hbWVfXxAC
```

## Note temporaire

En attendant la création de l'index, la requête `getProductsBySeller` a été modifiée pour ne pas utiliser `orderBy('createdAt')`, ce qui évite l'erreur d'index manquant.
