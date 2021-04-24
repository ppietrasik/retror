export const getMetaAttribute = name => {
  const element = document.head.querySelector(`meta[name="${name}"]`);

  return element?.getAttribute("content");
};
