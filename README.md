# MoviesApp

Funcionalidades técnicas de la aplicación:

Desarrollada en Swift versión 5.10, las pantallas están contruidas utilizando XIBs, el patron de arquitectura utilizado es MVVM con Factory, Manager, Router y Adapter, se implementa un comportamiento reactivo de los closures con la ayuda de una clase de tipo Observable, se extiende la funcionalidad URLSession para el llamado de los servicios, se implementan pruebas unitarias utilizando un mock que devuelve un listado de películas y con este se testean los métodos del ViewModel.

## Arquitectura:

Capas de la arquitectura:

- Model: Para las entidades
- View: Para componentes visuales y lógica de vista
- ViewModel: Para lógica de negocios
- Manager: Para la obtención de los datos
- Router: Para la navegación entre controladores
- Factory: Para la construcción de objetos complejos
- Adapter: Para los delegados y datasource del tableView

## Generalidades:

- En la pantalla principal hay una barra de búsqueda que filtra las peliculas acorde al texto que recibe, el filtro se realiza dependiendo de la sección en que se encuentra el usuario(populars, topRated), si no encuentra resultados para la búsqueda mostrará una alerta
- En la pantalla principal hay un botón que muestra un PickerView el cual no permite filtrar las peliculas que tenemos en el listado, una vez se realizan los filtros se mostrará un botón para deshacerlos, en caso de no obtener resultados se mostrará una alerta
- En la pantalla principal se mostrará un listado de peliculas dependiendo de la selección del SegmentedControl
- Al dar tap en una celda nos llevará a la pantalla de detalle(título, poster, sinópsis, etc...)
- El ActivityIndicator se muestra cuando se está obteniendo peliculas y se oculta cuando las obtuvo
- Cuando no se logra obtener datos se mostrará  una alerta
