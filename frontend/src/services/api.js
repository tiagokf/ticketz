import axios from "axios";
import { getBackendURL } from "../services/config";

const api = axios.create({
	baseURL: getBackendURL(),
	withCredentials: true,
});

export const openApi = axios.create({
	baseURL: getBackendURL()
});

// Interceptor para adicionar ENV_TOKEN em requisições public-settings
openApi.interceptors.request.use(
	(config) => {
		// Para rotas public-settings, adicionar o ENV_TOKEN
		if (config.url && config.url.includes('/public-settings/')) {
			// Tentar obter ENV_TOKEN do window ou localStorage
			const envToken = window.__APP_ENV_TOKEN__ || localStorage.getItem('ENV_TOKEN');
			if (envToken) {
				config.params = config.params || {};
				config.params.token = envToken;
			}
		}
		return config;
	},
	(error) => {
		return Promise.reject(error);
	}
);

export default api;
