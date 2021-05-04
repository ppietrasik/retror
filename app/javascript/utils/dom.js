const getElementIndex = (element, parent) => Array.prototype.indexOf.call(parent.children, element);

export const moveElement = (element, index) => {
  const partent = element.parentNode;
  const elementAtIndex = partent.children[index];
  const currentIndex = getElementIndex(element, partent);
  
  if(currentIndex == index) return;

  const referenceElement = currentIndex > index ? elementAtIndex : elementAtIndex.nextSibling;
  partent.insertBefore(element, referenceElement);
};

export const moveCaretToTheEnd = element => element.setSelectionRange(element.value.length, element.value.length);
