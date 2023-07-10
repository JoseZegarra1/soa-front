# Etapa de construcción
FROM node:14.20 as build

WORKDIR /app

# Copia los archivos de la aplicación
COPY package.json package-lock.json ./
COPY src ./src

# Instala las dependencias
RUN npm install

COPY . .

# Compila la aplicación
RUN npm run build --prod

# Busca el archivo nginx.conf dentro del contenedor
RUN find /app -name "nginx.conf" -type f -exec cp {} /app/nginx.conf \;
# Etapa de producción
FROM nginx:1.21.0-alpine

# Copia los archivos de la etapa de construcción
COPY --from=build /app/:dist/sakai-ng /usr/share/nginx/html

# Expone el puerto 80 para acceder a la aplicación
EXPOSE 80

# Comando para iniciar NGINX
CMD ["nginx", "-g", "daemon off;"]
