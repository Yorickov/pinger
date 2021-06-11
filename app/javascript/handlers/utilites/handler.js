export default (event) => {
  const { target, detail } = event;
  if (!target.classList.contains('ping-link')) {
    return;
  }

  event.preventDefault();

  const [data, _status, _xhr] = detail;
  const { status, response_time } = data;
  const pingBoxNode = document.querySelector('.ping-wrapper .ping-box');
  if (pingBoxNode.children.length > 0) {
    pingBoxNode.innerHTML = '';
  }

  const pingInfoNode = document.createElement('div');
  const baseClasses = ['mb-3', 'card-text'];
  const optClass = status == 'errored' ? 'text-danger' : 'text-success';
  pingInfoNode.classList.add(...baseClasses, optClass);

  const optContent = status === 'errored' ? '' : ` Response time: ${response_time}`;
  const content = `Status: ${status}.${optContent}`;
  pingInfoNode.textContent = content;

  pingBoxNode.append(pingInfoNode);
};
