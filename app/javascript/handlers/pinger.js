const handler = (event) => {
  const { target, detail } = event;
  if (!target.classList.contains('ping-link')) {
    return;
  }

  event.preventDefault();

  const { id, status } = detail[0];
  const siteNode = document.querySelector(`[data-site-id="${id}"]`);
  if (siteNode.children.length > 0) {
    siteNode.innerHTML = '';
  }
  const pingInfoNode = document.createElement('div');
  pingInfoNode.classList.add('mb-3', 'card-text')
  const optContent = status === 'errored' ? '' : ` Response: ${detail[0].response_time}`;
  const content = `Status: ${status}${optContent}`;
  pingInfoNode.innerHTML = content;
  siteNode.append(pingInfoNode);
};

const errorHandler = (event) => {
  const { target, detail } = event;
  if (!target.classList.contains('ping-link')) {
    return;
  }

  const { message } = detail[0];
  if (message) {
    const siteNode = document.querySelector(`[data-site-id="${id}"]`);
    const errorNode = `<div>${message}</div>`
    siteNode.insertAdjacentHTML('afterEnd', errorNode);
  }
};

export default () => {
  const control = document.querySelector('.site-info');
  if (control) {
    control.addEventListener('ajax:success', handler);
    control.addEventListener('ajax:error', errorHandler);
  }
};
