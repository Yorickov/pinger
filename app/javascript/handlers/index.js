import pinger from './pinger';

export default () => {
  document.addEventListener('turbolinks:load', () => {
    pinger();
  });
}
