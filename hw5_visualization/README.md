# Домашнее задание 5. Визуализация структуры белка

ПО для визуализации: __PyMOL__

Структура белка: https://www.rcsb.org/structure/4HHB

## Визуализации

### Wireframe
![Wireframe](pictures/wireframe.png)

### Backbone
![Backbone](pictures/backbone.png)

### Spacefill (с цветовой моделью CPK)
![Spacefill](pictures/spacefill.png)

### Ribbons (с расскраской по частям белка)
![Ribbons](pictures/ribbons.png)

### Molecular surface
![Molecular surface](pictures/surface.png)

### Публикационного качества
![Molecular surface](pictures/publication.png)


## Способ получения визуализации

### Wireframe
protein_model -> S (show) -> as -> wire (lines)

![Wireframe guide](pictures/wireframe_guide.png)

### Backbone
protein_model -> S (show) -> ribbon

![Backbone guide](pictures/backbone_guide.png)


### Ribbons
protein_model -> S (show) -> cartoon

![Ribbons guide](pictures/ribbons_guide.png)

### Molecular surface
protein_model -> S (show) -> surface

![Molecular surface guide](pictures/surface_guide.png)

### Раскраска по доменам белка
protein_model -> C (color) -> by chain -> by chain

![Color by chain](pictures/color_chain.png)

### Цветовая модель CPK
![CPK](pictures/cpk.png)

по крайней мере самое близкое к CPK, что я нашёл