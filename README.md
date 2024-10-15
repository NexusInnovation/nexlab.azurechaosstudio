# nexlab.azurechaosstudio
Exploration d'Azure Chaos Studio et du Chaos testing.

# Introduction
L'idée initiale de ce nexlab était de 
- Se familiariser avec Azure Chaos Studio
- Voir sa mise en application et son potentiel d'utilisation
- Voir si les prochaines étapes advenant sa valeur

## Qu'est-ce que le Chaos Testing ?
Que se passe-t-il dans votre application si votre base de données devient subitement inaccessible ? Le savez-vous ? On se doute que "ça ne fonctionnera pas", mais encore ? Quel comportement vous attendez-vous d'avoir et comment savez-vous que c'est ce qui se produit ?

C'est l'idée du Chaos Testing. Rendre des services indisponibles ou autres fautes (ie: accès refusé) afin de savoir si notre système réagit selon nos attentes dans ces circonstances.

## Qu'est-ce que Azure Chaos Studio ?
C'est le service Azure permettant de causer des fautes dans vos services Azure (et de les rétablir après !)

Il ne fait que causer des fautes à proprement dire et non roulé des tests.

Les actions entreprises sont réelles, alors il n'est pas recommandé de testé sur votre environnement de Production 😉

# Ce que contient ce projet
Commençons déjà par dire que ceci est un lab, donc exploratoire. L'emphase n'a donc pas été mis sur la sécurité ou une qualité de Production. Du moins, ça n'accote pas la qualité de nos projets chez Nexus.

- Quelques routes de base qui servent simplement à remplir l'idée de tester Azure Chaos Studio
- Infrasture-as-code afin de déployer l'infrastructure sur Azure
- Un pipeline YAML permettant le CI / CD qui utilise l'infrastructure-as-code et roule les tests de Chaos Studio

# Est-ce qu'Azure Chaos Studio vaut la peine ?
En ce qui me concerne, pas pour l'instant. Ça me semble trop peu mature encore pour avoir une réelle valeur ajoutée, même si l'idée est intéressante. Je serais plutôt porté à revisiter dans 1 an. Le gros problème pour moi est que la majorité des fautes disponibles ciblent des VMs ou AKS. Si vous utilisez des App Service ou Azure Container Apps par exemple, vous n'aurez rien d'intéressant pour vous. Rendu là, on peut peut-être faire mieux avec Azure CLI, mais ça défait le but de l'outil. C'est d'ailleurs ainsi que j'ai testé que mes comportement attendus étaient bon dans mon pipeline.

# Est-ce que le Chaos Testing vaut la peine ?
La question dépasse le sujet, mais je voulais quand même calmer les ardeurs que certains pourraient avoir. Pour moi l'intérêt est réel, mais il y a un coût à mettre ce type de test en place et ça prend une certaines maturité aussi: ne faites pas de Chaos Testing si vous faites à peine des tests unitaires.

# Petite réflexion finale
Le but du Chaos Testing n'est pas de s'assurer que votre système réagisse parfaitement en appliquant un failover d'une BD ou que de l'autoscaling se produit adéquatemment en cas de surcharge. C'est de savoir si votre système réagit selon VOS besoins et votre capacité. Avoir plusieurs instances ou avoir plusieurs BDs avec un failover, ça n'est pas gratuit et peut-être n'avez pas le budget pour ça. Peut-être que pour vous, de recevoir une alerte afin d'agir proactivement avant qu'un client vous appelle est tout ce dont vous avez besoin.
