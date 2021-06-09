import handler from './utilites/handler';
import errorHandler from './utilites/errorHandler';

const beforeHandler = (event) => {
  const { target } = event;
  if (!target.classList.contains('ping-link')) {
    return;
  }

  // TODO: precise selectors
  const protocol = document.getElementById('site_protocol');
  const url = document.getElementById('site_url');

  const preparedUrl = `${protocol.value}${url.value}`;
  target.dataset.params = `url=${preparedUrl}`;
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
