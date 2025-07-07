/projet-finance/
├── app/
│   ├── controllers/
│   │   ├── EtablissementController.php
│   │   ├── FondController.php
│   │   ├── TypePretController.php
│   │   ├── ClientController.php
│   │   ├── PretController.php
│   │   └── RemboursementController.php
│   ├── models/
│   │   ├── EtablissementModel.php
│   │   ├── FondModel.php
│   │   ├── TypePretModel.php
│   │   ├── ClientModel.php
│   │   ├── PretModel.php
│   │   └── RemboursementModel.php
│   ├── services/
│   │   ├── CalculService.php 
│   │   └── NotificationService.php
│   └── views/
│       ├── etablissement/
│       ├── fonds/
│       ├── types-pret/
│       ├── clients/
│       ├── prets/
│       └── remboursements/
├── config/
│   ├── database.php
│   ├── routes.php
│   └── constants.php
├── public/
│   ├── assets/
│   │   ├── css/
│   │   ├── js/
│   │   │   ├── app.js
│   │   │   ├── fonds.js
│   │   │   ├── prets.js
│   │   │   └── clients.js
│   │   └── images/
│   ├── api/ 
│   └── index.php
├── migrations/ 
├── tests/
└── vendor/