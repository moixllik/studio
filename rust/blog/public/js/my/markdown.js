class MyMarkdown extends HTMLElement {
    constructor() {
        super();
        this.style.whiteSpace = 'pre-wrap';
        this.matches = [];

        this.add(/^\#\# (.*)/gm, '<h2>$1</h2>');
        this.add(/^\#\#\# (.*)/gm, '<h3>$1</h3>');

        this.add(/^\`\`\`$/gm, '\n</my-code></pre>');
        this.add(/^\`\`\`(.*)/gm, '<pre><my-code data-lang="$1">');

        this.add(/\`(.*?)\`/g, '<code>$1</code>');

        this.add(/\!\[(.*?)\]\((.*?)\)/g, '<figure><img alt="$1" src="$2" width="100%" height="100%"></figure>');

        this.add(/\[(.*?)\]\((.*?)\)/g, '<a href="$2" target="_blank">$1</a>');

        this.format();
    }
    add(match, result) {
        this.matches.push([match, result]);
    }
    format() {
        let text = this.innerText;
        this.matches.forEach(it => {
            text = text.replace(it[0], it[1]);
        });
        this.innerHTML = text;
    }
}
customElements.define('my-markdown', MyMarkdown);
