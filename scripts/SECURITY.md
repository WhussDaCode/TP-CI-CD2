# Politique de Sécurité

## Gestion des Secrets

Ce projet respecte les bonnes pratiques DevOps. **Aucun secret n'est stocké dans le code source.**
Tous les identifiants sensibles sont gérés via les **GitHub Actions Secrets** et injectés dynamiquement lors de l'exécution du pipeline.

### Liste des Secrets utilisés en CI/CD

| Nom du Secret | Description | Utilisation |
| :--- | :--- | :--- |
| `VM_HOST` | Adresse IP publique de la VM de production | Utilisé pour la connexion SSH lors du déploiement. |
| `VM_USERNAME` | Nom d'utilisateur SSH | Utilisé pour s'authentifier sur la VM. |
| `VM_SSH_KEY` | Clé privée SSH | Permet la connexion sans mot de passe (clé publique installée sur la VM). |
| `TEST_DATABASE_URL` | URL de connexion à la base de données | Injectée dans le conteneur Docker en production et pour les tests. |
| `JWT_SECRET` | Clé privée pour signer les Tokens JWT | Sécurise l'authentification de l'API. |

## Rapports de Vulnérabilités

Si vous trouvez une faille de sécurité, merci d'ouvrir une issue privée ou de contacter l'équipe.
