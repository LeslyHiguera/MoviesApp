# MoviesApp

Funcionalidades técnicas de la aplicación:

Desarrollada en Swift versión 5.10, las pantallas están contruidas utilizando XIBs, el patron de arquitectura utilizado es MVVM con Factory, Manager, Router y Adapter, se implementa un comportamiento reactivo de los closures con la ayuda de una clase de tipo Observable, se extiende la funcionalidad URLSession para el llamado de los servicios,  

Arquitectura:

Capas de la arquitectura:

Model: Para las entidades
View: Para componentes visuales y lógica de vista
ViewModel: Para lógica de negocios
Manager: Para la obtención de los datos
Router: Para la navegación entre controladores
Factory: Para la construcción de objetos complejos
Adapter: Para los delegados y datasource del tableView

Generalidades:
