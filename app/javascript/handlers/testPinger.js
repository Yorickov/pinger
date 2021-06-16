import queryString from 'query-string';
import handler from './utilites/handler';
import errorHandler from './utilites/errorHandler';

const beforeHandler = (event) => {
  const { target } = event;
  if (!target.classList.contains('ping-link')) {
    return;
  }

  const protocol = document.querySelector('.site-form #site_protocol');
  const url = document.querySelector('.site-form #site_url');
  const timeout = document.querySelector('.site-form #site_timeout');
  const checkingString = document.querySelector('.site-form #site_checking_string');

  const queryParams = { url: `${protocol.value}${url.value}`, timeout: timeout.value, checking_string: checkingString.value }
  target.dataset.params = queryString.stringify(queryParams);
};

export default () => {
  const control = document.querySelector('.ping-wrapper');
  if (control) {
    control.addEventListener('ajax:success', handler);
    control.addEventListener('ajax:error', errorHandler);

    if (!control.parentNode.classList.contains('site-info')) {
      control.addEventListener('ajax:before', beforeHandler);
    }
  }
};
